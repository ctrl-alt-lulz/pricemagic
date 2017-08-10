class SeedProductsAndVariantsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1
  
  def perform
      rake products:seed    
      rake variants:seed
  end
end