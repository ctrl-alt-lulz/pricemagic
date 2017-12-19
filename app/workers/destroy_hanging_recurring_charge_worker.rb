class DestroyHangingRecurringChargeWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  def perform(id)
    shop = Shop.find(id)
    shop.with_shopify!
    if shop.recurring_charges.last['charge_data']['status'] == 'pending'
      shop.recurring_charges.delete_all
    end
    unless ShopifyAPI::RecurringApplicationCharge.current.nil?
      begin
        ShopifyAPI::RecurringApplicationCharge.current.destroy
      rescue => e
        puts e.inspect
      end
    end
  end
end