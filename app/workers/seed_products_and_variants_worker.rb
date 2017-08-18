class SeedProductsAndVariantsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1
  
  ## Write this as separate workers. 1 worker seeds products, 1 seed variants
  ## Iterate through shops just like you iterate through pages
  def perform
    Shop.all.each do |shop|
      shop.seed_products!
      shop.seed_variants!
      ## if variants isnt loaded when new product is seeded error will occur on dashboard page
      # rake variants:seed ## TODO handle for variants
    end 
  end
end