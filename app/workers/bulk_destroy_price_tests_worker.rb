class BulkDestroyPriceTestsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 10
  
  def perform(product_ids)
    shop = Product.find(product_ids.first).shop
    shop.with_shopify!
    PriceTest.where(product_id: product_ids, active: true).try(:destroy_all)
  end
end