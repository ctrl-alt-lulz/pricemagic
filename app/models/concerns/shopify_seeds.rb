module ShopifySeeds
  def seed_products!
    shop = self.with_shopify!
    products = (1..(ShopifyAPI::Product.count.to_f/150.0).ceil).flat_map do |page|
      ShopifyAPI::Product.find(:all, :params => {:page => page.to_i, :limit => 150})
    end
    # create local products
    products.each do |product|
      ## What if product title changes? update attribute condition?
      ## What about deleting products that don't exist anymore?
      next if Product.where(shopify_product_id: product.id).any?
      p = Product.new(title: product.title, shopify_product_id: product.id,
                      product_type: product.product_type, tags: product.tags, 
                      shop_id: id)
      p.save
      puts p.errors.inspect if p.errors.any?
    end
    puts Product.count
  end
  
  def seed_variants!
    ## Move variant code here so you get reuse inside of your workers
    shop = self.with_shopify!
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
          shopify_product.variants.new(shopify_variant_id: variant.id.to_s,
                                    variant_title: variant.title.to_s, 
                                    variant_price: variant.price.to_s)
        end
        shopify_product.save
        puts shopify_product.errors.inspect if shopify_product.errors.any?
      end
    end
  end
  
  def seed_collects!
    shop = self.with_shopify!
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
  end
  
  def seed_collections!
    shop = self.with_shopify!
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