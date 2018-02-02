class ShopUpdateWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(id, plan_name)
    shop = Shop.find(id)

    if shop.affiliate? && plan_name != "affiliate"
      shop.with_shopify!
      shop.update_attributes(affiliate: false)
      shop.recurring_charges.delete_all
      begin
        ShopifyAPI::RecurringApplicationCharge.current.destroy
      rescue => e
        puts e.inspect
      end
    end
  end
end
