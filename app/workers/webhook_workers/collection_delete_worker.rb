class CollectionDeleteWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(shopify_collection_id, shop_id)
    shop = Shop.find(shop_id)
    begin
      shop.collections.find_by(shopify_collection_id: shopify_collection_id).destroy
    rescue => e
      puts e.inspect
      shop.collections.find_by(shopify_collection_id: shopify_collection_id).delete
    end
  end
end