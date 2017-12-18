class GetShopOwnerEmailWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 10

  def perform(id)
    shop = Shop.find(id)
    shop.with_shopify!
    shop.update_attributes(shop_email: ShopifyAPI::Shop.current.email)
  end
end