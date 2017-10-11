class BulkDestroyPriceTestsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1
  
  def perform(product_ids)
    shop = PriceTest.find_by(product_id: product_ids.first).shop
    shop.with_shopify!
    PriceTest.where(product_id: product_ids, active: true).try(:destroy_all)
  end
end