class DestroyHangingRecurringChargeWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  def perform(id)
    shop = Shop.find(id)
    shop.with_shopify!
    if ShopifyAPI::RecurringApplicationCharge.current.nil?
      shop.recurring_charges.delete_all
    end
  end
end