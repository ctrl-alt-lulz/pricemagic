class CollectionDeleteWorker
  include Sidekiq::Worker
  sidekiq_options retry: 15

  def perform(shopify_collection_id, shop_id)
    shop = Shop.find(shop_id)
    shop.collections.find_by(shopify_collection_id: shopify_collection_id).destroy
  end
end