class PriceTest < ActiveRecord::Base
  validates :product_id, presence: true
  validates :price_data, presence: true
  ## TODO validate :no_active_price_tests_for_product
  before_validation :seed_price_data, if: proc { price_data.nil? }
  # after_create :apply_test_to_product ## TODO get apply_price_increase! working in the console
  # after_create :revert_price_to_base!

  scope :active, ->{ where(active: true) }
  scope :inactive, ->{ where(active: false) }

  def product
    @product ||= ShopifyAPI::Product.find(product_id)
  end

  def init_percent_increase
    self[:percent_increase] ||= 0
  end

  def init_percent_decrease
    self[:percent_decrease] ||= 0
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

  ## TODO write this method -done
  def revert_price_to_base!
    variants.each do |variant|
      variant.price = price_data[variant.id.to_s]['base_price']
    end
    product.save
  end

  def variants
    product.variants
  end

  ## TODO make percent_increase a percent, right now its an integer. -done
  ## ie., 10 rather than 1.10
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
    convert_inputs
    empty_hash = {}
    variants.each{ |variant| empty_hash.merge!(variant_hash(variant)) }
    empty_hash
  end

  private

  ## TODO rip this out
  def apply_test_to_product
    self.apply_price_increase!
  end

  def seed_price_data
    self.price_data = raw_price_data
  end

  def percent_increase_to_percent
    self[:percent_increase] = 1 + self[:percent_increase]/100
  end

  def percent_decrease_to_percent
    self[:percent_decrease] = 1 - self[:percent_decrease]/100
  end

  def convert_inputs
    init_percent_decrease
    init_percent_increase
    percent_increase_to_percent
    percent_decrease_to_percent
  end

  def make_ending_digits(price)
    price.round(0) + 0.99
  end
end
