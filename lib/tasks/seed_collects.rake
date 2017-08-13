namespace :collects do
  desc "Seeds the shopify product variants to local model"
  ## TODO extract this into a worker that runs every day
  task seed: :environment do
    # get the external produts
    shop = Shop.first
    shop.with_shopify!
    c = (1..(ShopifyAPI::Collect.count.to_f/250.0).ceil).flat_map do |page|
      ShopifyAPI::Collect.find(:all, :params => {:page => page.to_i, :limit => 150})
    end
    c.each do |collect|
      next if Collect.find_by(shopify_collect_id: collect.id)
      product = Product.find_by(shopify_product_id: collect.product_id.to_s)
      collection = Collection.find_by(shopify_collection_id: collect.collection_id.to_s)
      col = Collect.new(shopify_collect_id: collect.collection_id,
                        position: collect.position,
                        product_id: product.id,
                        collection_id: collection.id)  
      col.save
      puts col.errors.inspect if col.errors.any?
    end
    puts Collect.count
  end
end
