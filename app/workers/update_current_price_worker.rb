class UpdateCurrentPriceWorker
  include Sidekiq::Worker
  sidekiq_options retry: 15
  
  def perform(id)
    price_test = PriceTest.find(id)
    shop = price_test.shop
    shop.with_shopify!
    price_test.apply_current_test_price!
  end
end