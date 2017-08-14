namespace :collects do
  desc "Seeds the shopify product variants to local model"
  ## TODO extract this into a worker that runs every day
  task seed: :environment do
    # get the external produts
    Shop.all.each do |shop|
      shop.seed_collects!
    end
  end
end
