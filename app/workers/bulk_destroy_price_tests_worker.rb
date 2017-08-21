class BulkDestroyPriceTestsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1
  
  def perform(params)
    shop = PriceTest.find(params.first).shop.id
    shop = Shop.find(shop)
    shop.with_shopify!
    PriceTest.where(id: params, active: true).try(:destroy_all)
  end
end