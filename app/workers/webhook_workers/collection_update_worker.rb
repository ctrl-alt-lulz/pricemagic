class CollectionUpdateWorker
  include Sidekiq::Worker
  sidekiq_options retry: 15

  def perform(shop_id, shopify_collection_id, title)
    shop = Shop.find(shop_id)
    local_collection = shop.collections.find_by(shopify_collection_id: shopify_collection_id)
    local_collection.update_attributes(title: title)
    shop.seed_collects!
  end
end