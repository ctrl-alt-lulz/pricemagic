class DestroyRecurringChargesWorker
  include Sidekiq::Worker
  sidekiq_options retry: 15

  def perform(shop_id)
    shop = Shop.find(shop_id)
    begin
      shop.recurring_charges.destroy_all
    rescue => e
      puts e.inspect
      shop.recurring_charges.delete_all
    end
  end
end