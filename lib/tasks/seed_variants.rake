namespace :variants do
  desc "Seeds the shopify product variants to local model"
  ## TODO extract this into a worker that runs every day
  task seed: :environment do
    # get the external produts
    shop = Shop.first
    shop.with_shopify!
    products = (1..(ShopifyAPI::Product.count.to_f/150.0).ceil).flat_map do |page|
      ShopifyAPI::Product.find(:all, :params => {:page => page.to_i, :limit => 150})
    end
    products.each do |product|
      shopify_product = Product.where(shopify_product_id: product.id.to_s).first
      product.variants.each do |variant|
        pv = shopify_product.variants.find_by(shopify_variant_id: variant.id.to_s)
        # updates variant if already exists, otherwise creates new variant
        if !pv.nil? && shopify_product.variants.any? 
          pv.update_attributes(variant_title: variant.title.to_s, 
                               variant_price: variant.price.to_s)
        else 
          shopify_product.variants.new(shopify_product_id: product.id.to_s, 
                                    shopify_variant_id: variant.id.to_s,
                                    variant_title: variant.title.to_s, 
                                    variant_price: variant.price.to_s)
        end
        shopify_product.save
        puts shopify_product.errors.inspect if shopify_product.errors.any?
      end
    end
  end
end
