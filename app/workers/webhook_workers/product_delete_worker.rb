class ProductDeleteWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(shopify_product_id, shop_id)
    shop = Shop.find(shop_id)
    shop.products.find_by(shopify_product_id: shopify_product_id).destroy
  end
end