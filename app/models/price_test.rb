class PriceTest < ActiveRecord::Base
  validates :product_id, presence: true
  validates :price_data, presence: true
  validates :ending_digits, presence: true, numericality: true
  validates :percent_increase, :percent_decrease, numericality: true
  ## TODO validate :no_active_price_tests_for_product
  before_validation :seed_price_data, if: proc { price_data.nil? }
  ## TODO need to keep track of dates price test starts/ends can select days to run or views
  ## TODO be able to configure settings and then submit/start/ goes active 
  ## ties in with #of price steps chosen
  
  scope :active, ->{ where(active: true) }
  scope :inactive, ->{ where(active: false) }
  def product
    @product ||= ShopifyAPI::Product.find(product_id)
  end

  def apply_price_increase!
    variants.each do |variant|
      variant.price = price_data[variant.id.to_s]['price_ceiling']
    end
    product.save
  end

  def apply_price_decrease!
    variants.each do |variant|
      variant.price = price_data[variant.id.to_s]['price_basement']
    end
    product.save
  end

  def revert_price_to_base!
    variants.each do |variant|
      variant.price = price_data[variant.id.to_s]['base_price']
    end
    product.save
  end

  def variants
    product.variants
  end

  def variant_hash(variant)
    {
      variant.id => {
        base_price: make_ending_digits(variant.price.to_f),
        price_ceiling: make_ending_digits(variant.price.to_f * percent_increase),
        price_basement: make_ending_digits(variant.price.to_f * percent_decrease)
      }
    }
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
  ## TODO find max price steps
  ## TODO figure out how to get steps working ie array of [price_basement, price1, price2, price_ceiling]
  ## maybe set a maximum of 4 and it will set up to 4/max?
  # def max_price_steps
  #   price_ceiling - price_basement
  # end
  
  def seed_price_data
    self.price_data = raw_price_data
  end

  def make_ending_digits(price)
    price.floor + self.ending_digits
  end
end
