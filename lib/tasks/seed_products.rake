namespace :products do
  desc "Seeds the shopify products to local model"
  ## TODO extract this into a worker that runs every day
  task seed: :environment do
    # get the external produts
    shop = Shop.first
    shop.with_shopify!
    products = []
    for page in (1..(ShopifyAPI::Product.count.to_f/150.0).ceil)
      products += ShopifyAPI::Product.find(:all, :params => {:page => page, :limit => 150})
    end
    # create local products
    products.each do |product|
      ## What if product title changes? update attribute condition?
      ## What about deleting products that don't exist anymore?
      next if Product.where(shopify_product_id: product.id).any?
      p = Product.new(title: product.title, shopify_product_id: product.id, product_type: product.product_type, tags: product.tags)
      p.save
      puts p.errors.inspect if p.errors.any?
    end
    puts Product.count
  end
end
