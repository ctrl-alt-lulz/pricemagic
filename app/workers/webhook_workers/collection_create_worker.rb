class CollectionCreateWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(shop_id)
    shop = Shop.find(shop_id)
    shop.seed_collections!
    shop.seed_collects!
  end
end