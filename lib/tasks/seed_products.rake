namespace :products do
  desc "Seeds the shopify products to local model"
  ## TODO extract this into a worker that runs every day
  task seed: :environment do
    # get the external produts
    ## iterate through all shops
    Shop.all.each do |shop|
      shop.seed_products!
    end
  end
end
