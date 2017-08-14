class CheckPriceTestsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1
  
  def perform
    Shop.all.each do |shop|
    end 
  end
end