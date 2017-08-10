namespace :collects do
  desc "Seeds the shopify product variants to local model"
  ## TODO extract this into a worker that runs every day
  task seed: :environment do
    # get the external produts
    shop = Shop.first
    shop.with_shopify!
    c = []
    for page in (1..(ShopifyAPI::Collect.count.to_f/250.0).ceil)
      c += ShopifyAPI::Collect.find(:all, :params => {:page => page, :limit => 250})
    end
    c.each do |collect|
      next if Collect.find_by(collect_id: collect.id)
      col = Collect.new(shopify_product_id: collect.product_id, 
                        shopify_collection_id: collect.collection_id,
                        position: collect.position,
                        collect_id: collect.id)  
      col.save
      puts col.errors.inspect if col.errors.any?
    end
    puts Collect.count
  end
end

#collections = ShopifyAPI::SmartCollection.find(:all) + ShopifyAPI::CustomCollection.find(:all)

#@products = ShopifyAPI::Product.where(collection_id: params[:collection], title: params[:term])

  # def define_collection
  #     @collections ||=  ShopifyAPI::Collect.where(product_id: params[:id]).map do |c| 
  #                       { 
  #                         position: c.position, 
  #                         title: ShopifyAPI::SmartCollection.find(c.collection_id).title 
  #                       }
  #                     end
  # end