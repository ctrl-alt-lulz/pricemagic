class PriceTest < ActiveRecord::Base
  include PriceTestExtShopifyMethods
  belongs_to :product
  
  validates :view_threshold, numericality: { only_integer: true, greater_than: 0 }
  validates :product_id, :price_data, :view_threshold, presence: true
  validates :ending_digits, :price_points, presence: true, numericality: true
  validates :percent_increase, :percent_decrease, numericality: true
  validate :no_active_price_tests_for_product
  validate :trial_or_subscription
  before_validation :seed_price_data, if: proc { price_data.nil? }
  before_create :set_new_current_price_started_at
  after_create :apply_current_test_price_async!
  before_destroy :revert_to_original_price!, if: :active?
  ## OR make best price original price?
  
  delegate :shop, to: :product
  delegate :variants, to: :product
  delegate :latest_product_google_metric_views, to: :product, :allow_nil => true
  delegate :latest_product_google_metric_views_at, to: :product, :allow_nil => true
  delegate :latest_variant_google_metric_revenue, to: :variant, :allow_nil => true
  delegate :latest_variant_google_metric_revenue_at, to: :variant, :allow_nil => true

  scope :active, ->{ where(active: true) }
  scope :inactive, ->{ where(active: false) }
  
  ## coding practice to refactor below
  ## move graphing related code to seperate module
  def plot_data
    price_data.values.map.with_index do |hash, index| 
    { 
      y: hash['revenue'], 
      x: hash['price_points'],  
      z: variants[index].variant_title,
      unit_cost: variants[index].unit_cost,
      total_variant_views: hash['total_variant_views'] 
    } 
    end
  end
  
  def final_plot
   plot_data.map {|val| get_value(val) }
  end
  
  def get_value(hash)
    unit_cost = hash[:unit_cost]
    unit_cost = 0 if unit_cost.nil?
    a = hash[:y].map {|val| { y: val.round(2)} } 
    a = hash[:x].map{ { y: 0 } } if a.empty?
    b = hash[:x].map {|val| { x: val} }
    b = hash[:x].map{ { x: 0 } } if b.empty?
    total_variant_views = hash[:total_variant_views].map{|val| {total_variant_views: val}}
    total_variant_views = hash[:x].map{ { total_variant_views: 0 } } if total_variant_views.empty?
    analytics_hash = { z: hash[:z] }
    a.map.with_index do  |val,index| 
      if total_variant_views[index][:total_variant_views] == 0
        rev_per_view = 0
      else
        rev_per_view = a[index][:y]/total_variant_views[index][:total_variant_views] 
      end
      rev = a[index][:y]
      price_point = b[index][:x]
      profit = (rev-((rev/price_point)*unit_cost))
      views = total_variant_views[index][:total_variant_views]
      if views == 0 
        profit_per_view = 0
      else 
        profit_per_view = (profit/views).round(4)
      end
      val.merge(b[index]).
      merge(total_variant_views[index]).
      merge(analytics_hash).
      merge({rev_per_view: rev_per_view.round(4)}).
      merge({profit: (a[index][:y]-((a[index][:y]/b[index][:x])*unit_cost)).round(2) }).
      merge({profit_per_view: profit_per_view })
    end
  end
  
  def total_views
    self['view_threshold'] * price_points
  end
  
  def total_views_so_far
    price_data.values.first['total_variant_views'].reduce(:+)  
  end
  
  def completion_percentage
    total_views_so_far.presence ? views_ratio : 0
  end
  
  def views_ratio
    (100 * (total_views_so_far.to_f/total_views))
  end
  
  def variant_hash(variant, price_multipler)
    price_points = price_multipler.collect { |n| make_ending_digits(n * variant.variant_price.to_f) }
    validate_price_points(price_points)
    {
      variant.shopify_variant_id =>  {
        original_price: make_ending_digits(variant.variant_price.to_f),
        current_test_price: price_points.first,
        total_variant_views: [], 
        price_points: price_points,
        tested_price_points: [],
        revenue: [], 
        starting_revenue: variant.latest_variant_google_metric_revenue,
        starting_page_views: latest_product_google_metric_views
      }
    }
  end
  
  def raw_price_data
    empty_hash = {}
    price_multipler = calc_price_multipler(self[:price_points])
    variants.each{ |variant| empty_hash.merge!(variant_hash(variant, price_multipler)) }
    empty_hash
  end
  
  ### TODO further testing of code
  def store_revenue_from_test
    price_data.each do |k, v|
      var = product.variants.where(shopify_variant_id: k).last
      v['revenue'] << var.latest_variant_google_metric_revenue - v['starting_revenue'].to_f
      v['starting_revenue'] = var.latest_variant_google_metric_revenue
    end
  end
  #######  
  
  def store_view_count_from_test
    price_data.each do |k, v|
      v['total_variant_views'] << page_views_since_create
    end
    price_data.each do |k, v|
      v['starting_page_views'] = latest_product_google_metric_views
    end
  end
  
  def page_views_since_create
    latest_product_google_metric_views - price_data.values.first['starting_page_views'].to_i
  end
  
  def hit_threshold?
    page_views_since_create >= self['view_threshold'].to_i
  end
  
  def make_inactive!
    revert_to_original_price!
    set_to_inactive
    set_new_current_price_started_at
    save
    ## TODO set price to original or best price
  end
  
  def done?
    price_data.try(:first).last['current_test_price'].nil?
  end
  
  def shift_price_point!
    move_current_test_price_to_tested
    store_view_count_from_test
    store_revenue_from_test
    set_new_test_price
    apply_current_test_price!
    set_new_current_price_started_at
    save
  end
  
  def percent_increase=(percent)
    self[:percent_increase] = 1 + percent.to_f/100
  end

  def percent_decrease=(percent)
    self[:percent_decrease] = 1 - percent.to_f/100
  end
  
  def as_json(options={})
    super(:methods => [:variants, :has_active_price_test, :final_plot])
  end
  
  private
  
  def trial_or_subscription
    return if shop.trial? || shop.has_subscription?
    errors.add(:base, "A subscription is required after your first price test!")
  end
  
  def set_to_inactive
    self.active = false
  end
  
  def set_new_current_price_started_at
    self.current_price_started_at = DateTime.now
  end
  
  def move_current_test_price_to_tested
    price_data.each do |k, v|
      return if v['current_test_price'].nil?
      v['tested_price_points'] << v['current_test_price']
    end
  end
  
  def set_new_test_price
    price_data.each do |k, v|
      v['current_test_price'] = (v['price_points'] - v['tested_price_points']).first
    end
  end
  
  def no_active_price_tests_for_product
    return if (PriceTest.where(product_id: product_id).active - [self]).empty?
    errors.add(:base, "Cannot have multiple active price tests!")
  end
  
  def seed_price_data
    self.price_data = raw_price_data
  end
  
  def make_ending_digits(price)
    price.floor + self.ending_digits
  end
  
  def calc_price_multipler(number_of_test_points)
    price_points = number_of_test_points
    price_multipler = [percent_increase]
    
    if (price_points == 1) 
      return price_multipler 
    elsif (price_points == 2) 
      price_multipler.unshift(percent_decrease)
      return price_multipler
    else 
      step = (percent_increase-percent_decrease)/(price_points-1)
      for i in 1...(price_points - 1)
        price_multipler.unshift(price_multipler[i-1] - step*i) 
      end
      price_multipler.unshift(percent_decrease)
      return price_multipler
    end
  end
    ## TODO maybe there is a better way? like stopping execution?
    ## How to only return one of error type? Currently using uniq method in pricetest controller
  def validate_price_points(pricePoints)
    if pricePoints != pricePoints.uniq  
      errors.add(:base, "Cannot have duplicate price points!")
    elsif pricePoints != pricePoints.sort
      errors.add(:base, "Price range is not sufficient, must order smallest to largest!") 
    else 
      return pricePoints
    end
  end
end
