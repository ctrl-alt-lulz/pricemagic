class RevertToOldPriceWorker
  include Sidekiq::Worker
  sidekiq_options retry: 15

  def perform(id)
    unless PriceTest.where(id: id).empty?
      price_test = PriceTest.find(id)
      shop = price_test.shop
      shop.with_shopify!
      price_test.revert_to_original_price!
    end
  end
end