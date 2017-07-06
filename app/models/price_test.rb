class PriceTest < ActiveRecord::Base
  validates :product_id, presence: true
  validates :price_data, presence: true

  ## TODO validate :no_active_price_tests_for_product

  before_validation :seed_price_data, if: proc { price_data.nil? }
  before_save :percent_decrease, :percent_increase
  # after_create :apply_test_to_product ## TODO get apply_price_increase! working in the console

  scope :active, ->{ where(active: true) }
  scope :inactive, ->{ where(active: false) }

  def product
    @product ||= ShopifyAPI::Product.find(product_id)
  end

  def percent_increase
    self[:percent_increase] ||= 0
  end

  def percent_decrease
    self[:percent_decrease] ||= 0
  end

  def apply_price_increase!
    variants.each do |variant|
      variant.price = price_data[variant.id.to_s]['price_ceiling']
    end
    product.save
  end

  ## TODO write this method
  def revert_price_to_base!

  end

  def variants
    product.variants
  end

  ## TODO make percent_increase a percent, right now its an integer.
  ## ie., 10 rather than 1.10
  def variant_hash(variant)
    {
      variant.id => {
        base_price: variant.price.to_f,
        price_ceiling: variant.price.to_f * 1+percent_increase/100.0,
        price_basement: variant.price.to_f * percent_decrease
      }
    }
  end

  def raw_price_data
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
end
