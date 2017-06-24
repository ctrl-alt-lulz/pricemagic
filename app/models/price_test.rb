class PriceTest < ActiveRecord::Base
  validates :product_id, presence: true

  def product
    #ShopifyAPI::Product.find(product_id)
  end
end
