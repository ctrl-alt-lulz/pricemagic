class PriceTest < ActiveRecord::Base
  validates :product_id, presence: true
  validates :price_data, presence: true
  validates :ending_digits, :price_points, presence: true, numericality: true
  validates :percent_increase, :percent_decrease, numericality: true
  validate :no_active_price_tests_for_product
  before_validation :seed_price_data, if: proc { price_data.nil? }
  after_validation
  ## TODO need to keep track of dates price test starts/ends can select days to run or views
  ## TODO be able to configure settings and then submit/start/ goes active 
  ## ties in with #of price steps chosen
  
  scope :active, ->{ where(active: true) }
  scope :inactive, ->{ where(active: false) }
  
  ## TODO handle product views across all variants
  #  def total_product_views
  #    ## TODO sum variant views for current test
  #  end 

  def product
    @product ||= ShopifyAPI::Product.find(product_id)
  end

  # def apply_price_increase!
  #   variants.each do |variant|
  #     variant.price = price_data[variant.id.to_s]['price_ceiling']
  #   end
  #   product.save
  # end

  # def apply_price_decrease!
  #   variants.each do |variant|
  #     variant.price = price_data[variant.id.to_s]['price_basement']
  #   end
  #   product.save
  # end

  def revert_price_to_base!
    variants.each do |variant|
      variant.price = price_data[variant.id.to_s]['original_price']
    end
    product.save
  end

  def variants
    product.variants
  end

  def variant_hash(variant)
    upperValue = make_ending_digits(variant.price.to_f * percent_increase)
    lowerValue =  make_ending_digits(variant.price.to_f * percent_decrease)
    {
      variant.id =>  {
        original_price: make_ending_digits(variant.price.to_f),
        current_test_price: nil,
        current_test_position: nil, ##TODO figure out how to shift as a function of below code
        total_variant_views: {}, ## TODO get views from google worker
        price_points: step_price_points(upperValue, lowerValue, self[:price_points]),
        tested_price_points: []
      }
    }
  end
  
  # p = PriceTest.last
  # p['price_data']['40061050756']['price_points']
  def set_test_position
    define_current_test_position_array
    shift_price_point
    variants.each do |variant|
      puts variant.id
    end
    # current_test_price: price_points[@current_test_position],
    # current_test_position: @current_test_position, ##TODO figure out how to shift as a function of below code
  end

  def define_current_test_position_array 
    @current_test_position_array = self[:price_points].times.map{|n| n}
  end
  
  def shift_price_point
    if @current_test_position_array.nil?
      ##TODO end test
    else
      @current_test_position = @current_test_position_array.shift
    end
  end
  
  def raw_price_data
    empty_hash = {}
    variants.each{ |variant| empty_hash.merge!(variant_hash(variant)) }
    empty_hash
  end

  def percent_increase=(percent)
    self[:percent_increase] = 1 + percent.to_f/100
  end

  def percent_decrease=(percent)
    self[:percent_decrease] = 1 - percent.to_f/100
  end
  
  private
  
  def no_active_price_tests_for_product
    return if PriceTest.where(product_id: product_id).active.empty?
    errors.add(:base, "Cannot have multiple active price tests!")
  end
  
  def seed_price_data
    self.price_data = raw_price_data
  end
  
  ## TODO, creates new start date when next price point is ready for test
  def price_test_start_date
    Time.now.strftime("%Y-%m-%d")
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
    pricePoints.push(upper);
    pricePoints = validate_price_points(pricePoints)
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
