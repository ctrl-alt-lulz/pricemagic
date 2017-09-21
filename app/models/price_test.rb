class PriceTest < ActiveRecord::Base
  include PriceTestExtShopifyMethods
  belongs_to :product
  
  validates :product_id, presence: true
  validates :price_data, presence: true
  validates :ending_digits, :price_points, presence: true, numericality: true
  validates :percent_increase, :percent_decrease, numericality: true
  validate :no_active_price_tests_for_product
  before_validation :seed_price_data, if: proc { price_data.nil? }
  before_create :set_new_current_price_started_at
  after_create :apply_current_test_price_async!
  before_destroy :revert_to_original_price!, if: :active?
  ## OR make best price original price?
  
  delegate :shop, to: :product
  delegate :variants, to: :product
  delegate :latest_product_google_metric_views, to: :product, :allow_nil => true
  delegate :latest_product_google_metric_views_at, to: :product, :allow_nil => true

  scope :active, ->{ where(active: true) }
  scope :inactive, ->{ where(active: false) }
  
  ## TODO handle product views across all variants
  #  def total_product_views
  #    ## TODO sum variant views for current test
  #  end 
  
  def variant_hash(variant, price_multipler)
    puts '*'*50
    puts price_multipler.class
    price_points = price_multipler.collect { |n| make_ending_digits(n * variant.variant_price.to_f) }
    {
      variant.shopify_variant_id =>  {
        original_price: make_ending_digits(variant.variant_price.to_f),
        current_test_price: price_points.first,
        total_variant_views: [], ## TODO get views from google worker
        price_points: price_points,
        tested_price_points: []
      }
    }
  end
  
  def raw_price_data
    empty_hash = {}
    price_multipler = calc_price_multipler(self[:price_points])
    variants.each{ |variant| empty_hash.merge!(variant_hash(variant, price_multipler)) }
    empty_hash
  end
  
  def latest_product_google_metric_views_at_start_of_price 
    latest_product_google_metric_views_at(current_price_started_at) 
  end

  def page_views_since_create
    if latest_product_google_metric_views_at_start_of_price
      latest_product_google_metric_views - latest_product_google_metric_views_at_start_of_price
    else
      latest_product_google_metric_views
    end
  end

  def hit_threshold?
    page_views_since_create >= view_threshold
  end
  
  def view_threshold
    0 ## TODO make this dependent on CI, price, etc.
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
    super(:methods => [:variants, :has_active_price_test])
  end
  
  private
  
  def set_to_inactive
    self.active = false
  end
  
  def store_view_count_from_test
    price_data.each do |k, v|
      v['total_variant_views'] << page_views_since_create
    end
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
  
  ## TODO refactor this
  def step_price_points(upper, lower, number_of_test_points)
    number_of_test_points -= 1
    pricePoints = []
    pricePoints.push(lower) if(number_of_test_points > 0) 
    step = (upper - lower)/number_of_test_points;
    for number_of_test_points in (1...number_of_test_points) do
      pricePoints.push(make_ending_digits(pricePoints[number_of_test_points-1] + step))
    end
    pricePoints.push(upper)
    pricePoints = validate_price_points(pricePoints)
  end
  
  def calc_price_multipler(number_of_test_points)
    percent_increase = self[:percent_increase]
    percent_decrease = self[:percent_decrease]
    price_points = number_of_test_points
    price_multipler = [percent_increase]
    
    return price_multipler if (price_points == 1) 
    if (price_points == 2) 
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
