class StopPriceTestsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 15

  def perform(id)
    shop = Shop.find(id)
    shop.with_shopify!
    shop.price_tests.active.each do |pt|
      pt.make_inactive!
    end
  end
end
