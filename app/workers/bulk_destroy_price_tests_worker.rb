class BulkDestroyPriceTestsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1
  
  def perform(product_ids)
    shop = PriceTest.find(product_ids.first).shop
    shop.with_shopify!
    PriceTest.where(id: product_ids, active: true).try(:destroy_all)
  end
end