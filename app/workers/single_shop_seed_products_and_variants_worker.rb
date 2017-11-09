class SingleShopSeedProductsAndVariantsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 10
  
  ## Write this as separate workers. 1 worker seeds products, 1 seed variants
  ## Iterate through shops just like you iterate through pages
  def perform(id)
    shop = Shop.find(id)
    shop.seed_products!
    shop.seed_variants!
    shop.seed_collections!
    shop.seed_collects!
    ## if variants arent loaded when new product is seeded error will occur on dashboard page
    # rake variants:seed ## TODO handle for variants
  end
end