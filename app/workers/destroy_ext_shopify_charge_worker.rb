class DestroyExtShopifyChargeWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  def perform(id)
    shop = Shop.find(id)
    shop.with_shopify!
    begin
      ShopifyAPI::RecurringApplicationCharge.current.destroy
    rescue => e
      puts e.inspect
    end
  end
end


