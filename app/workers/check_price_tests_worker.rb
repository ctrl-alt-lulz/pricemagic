class CheckPriceTestsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1
    ## TODO write worker to check price_tests for upgrades/closing
    ## CheckPriceTestsWorker.perform_async(shop_id)
  def perform
    Shop.all.each do |shop|
      
    end 
  end
end