class PriceTest < ActiveRecord::Base
  validates :product_id, presence: true
  validates :price_data, presence: true

  before_validate :seed_price_data, if: proc { price_data.nil? }

  def product
    ShopifyAPI::Product.find(product_id)
  end

  def percent_decrease
    self[:percent_decrease] || 0
  end

  def variants
    product.variants
  end

  def variant_hash(variant)
    {
      variant.id => {
        base_price: variant.price.to_f,
        price_ceiling: variant.price.to_f * percent_increase,
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

  def seed_price_data
    self.price_data = raw_price_data
  end
end
