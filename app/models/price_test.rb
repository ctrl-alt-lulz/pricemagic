class PriceTest < ActiveRecord::Base
  validates :product_id, presence: true
  validates :price_data, presence: true
  validates :percent_increase, :percent_decrease, numericality: true
  ## TODO validate :no_active_price_tests_for_product
  before_validation :seed_price_data, if: proc { price_data.nil? }
  ## TODO need to keep track of dates price test starts/ends
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
        base_price: variant.price.to_f.round(2),
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
    percent = percent.to_f
    percent ||= 0
    percent = 1 + percent/100
    write_attribute(:percent_increase, percent) ## written in two different ways (see below), is any way better than the other?
  end

  def percent_decrease=(percent)
    percent = percent.to_f
    percent ||= 0
    percent = 1 - percent/100
    self[:percent_decrease] = percent
  end
  private

  ## TODO rip this out
  def apply_test_to_product
    self.apply_price_increase!
  end

  def seed_price_data
    self.price_data = raw_price_data
  end

  def make_ending_digits(price)
    price.floor + 0.99
    ## TODO make the 0.99 ending customizable, will need to add field to price test data model
  end

end
