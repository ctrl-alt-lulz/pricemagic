namespace :collections do
  desc "Seeds the shopify product variants to local model"
  ## TODO extract this into a worker that runs every day
  task seed: :environment do
    # get the external produts
    shop = Shop.first
    shop.with_shopify!
    c = (1..(ShopifyAPI::SmartCollection.count.to_f/150.0).ceil).flat_map do |page|
      ShopifyAPI::SmartCollection.find(:all, :params => {:page => page.to_i, :limit => 150})
    end
    c.each do |collect|
      next if Collection.find_by(shopify_collection_id: collect.id)
      col = Collection.new(title: collect.title, 
                        shopify_collection_id: collect.id,
                        collection_type: "Smart")  
      col.save
      puts col.errors.inspect if col.errors.any?
    end
    c = []
    c = (1..(ShopifyAPI::CustomCollection.count.to_f/150.0).ceil).flat_map do |page|
      ShopifyAPI::CustomCollection.find(:all, :params => {:page => page.to_i, :limit => 150})
    end
    c.each do |collect|
      next if Collection.find_by(shopify_collection_id: collect.id)
      col = Collection.new(title: collect.title, 
                        shopify_collection_id: collect.id,
                        collection_type: "Custom")  
      col.save
      puts col.errors.inspect if col.errors.any?
    end
  end
end