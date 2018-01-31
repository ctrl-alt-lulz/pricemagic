module ShopifySeeds
  def seed_products!
    self.with_shopify!
    products = (1..(ShopifyAPI::Product.count.to_f/150.0).ceil).flat_map do |page|
      ShopifyAPI::Product.find(:all, :params => {:page => page.to_i, :limit => 150})
    end
    shopify_product_ids = products.map(&:id)
    local_products = Product.where(shopify_product_id: shopify_product_ids).pluck(:shopify_product_id, :id)
    product_ids = Hash[local_products]
    product_array = []
    products.map do |product|
      next if product_ids[product.id.to_s]
      product_array << Product.new(title: product.title, shopify_product_id: product.id,
                      product_type: product.product_type, tags: product.tags, 
                      shop_id: id, main_image_src: product.images.first.try(:src))
    end
    Product.import product_array
  end
  
  def seed_variants!
    ## Move variant code here so you get reuse inside of your workers
    self.with_shopify!
    products = (1..(ShopifyAPI::Product.count.to_f/150.0).ceil).flat_map do |page|
      ShopifyAPI::Product.find(:all, :params => {:page => page.to_i, :limit => 150})
    end
    variant_array = []
    ## TODO figure out how to get product below optimized
    products.each do |product|
      shopify_product = Product.where(shopify_product_id: product.id.to_s).first
      product.variants.each do |variant|
        pv = shopify_product.variants.find_by(shopify_variant_id: variant.id.to_s)
        # updates variant if already exists, otherwise creates new variant
        if !pv.nil? && shopify_product.variants.any? 
          pv.update_attributes(variant_title: variant.title.to_s, 
                               variant_price: variant.price.to_s)
        else
          variant_array << shopify_product.variants.new(shopify_variant_id: variant.id.to_s,
                                    variant_title: variant.title.to_s, 
                                    variant_price: variant.price.to_s)
        end
      end
    end
    Variant.import variant_array
  end
  
  #collections must be defined first
  def seed_collects!
    self.with_shopify!
    c = (1..(ShopifyAPI::Collect.count.to_f/250.0).ceil).flat_map do |page|
      ShopifyAPI::Collect.find(:all, :params => {:page => page.to_i, :limit => 150})
    end
    shopify_collect_ids    = c.map(&:id)
    shopify_product_ids    = c.map(&:product_id)
    shopify_collection_ids = c.map(&:collection_id)

    collects    = Collect.where(shopify_collect_id: shopify_collect_ids).pluck(:shopify_collect_id, :id)
    collect_ids = Hash[collects]

    products    = Product.where(shopify_product_id: shopify_product_ids).pluck(:shopify_product_id, :id)
    product_ids = Hash[products]

    collections    = Collection.where(shopify_collection_id: shopify_collection_ids).pluck(:shopify_collection_id, :id)
    collection_ids = Hash[collections]
    col = []
    c.each do |collect|
      next if collect_ids[collect.id.to_s]
      col << Collect.new(shopify_collect_id: collect.id,
                        position: collect.position,
                        product_id: product_ids[collect.product_id.to_s],
                        collection_id: collection_ids[collect.collection_id.to_s],
                        shop_id: id)
    end
    Collect.import col
  end
  
  def seed_collections!
    self.with_shopify!
    sc = (1..(ShopifyAPI::SmartCollection.count.to_f/150.0).ceil).flat_map do |page|
      ShopifyAPI::SmartCollection.find(:all, :params => {:page => page.to_i, :limit => 150})
    end
    shopify_sc_ids = sc.map(&:id)
    collection_ids = Collection.where(shopify_collection_id: shopify_sc_ids).pluck(:shopify_collection_id, :id)
    collection_ids = Hash[collection_ids]
    scol = []
    sc.map do |collect|
      next if collection_ids[collect.id.to_s]
      scol << Collection.new(title: collect.title,
                        shopify_collection_id: collect.id,
                        collection_type: "Smart",
                        shop_id: id)
    end
    Collection.import scol

    cc = (1..(ShopifyAPI::CustomCollection.count.to_f/150.0).ceil).flat_map do |page|
      ShopifyAPI::CustomCollection.find(:all, :params => {:page => page.to_i, :limit => 150})
    end
    shopify_cc_ids = cc.map(&:id)
    collection_ids = Collection.where(shopify_collection_id: shopify_cc_ids).pluck(:shopify_collection_id, :id)
    collection_ids = Hash[collection_ids]
    ccol = []
    cc.map do |collect|
      next if collection_ids[collect.id.to_s]
      ccol << Collection.new(title: collect.title,
                        shopify_collection_id: collect.id,
                        collection_type: "Custom",
                        shop_id: id)
    end
    Collection.import ccol
  end
end