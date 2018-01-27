class UpdateProductWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(shopify_product_id, title, id, ext_shopify_variant_id_array )
    shop = Shop.find(id)
    shop.with_shopify!
    local_product = shop.products.find_by(shopify_product_id: shopify_product_id)
    unless local_product.price_tests.last.try(:active)
      local_variants  = shop.products.find_by(shopify_product_id: shopify_product_id).variants
      local_shopify_variant_id_array = local_variants.map{|variant| variant.shopify_variant_id.to_s }
      new_variant_id_array = ext_shopify_variant_id_array - local_shopify_variant_id_array
      local_product.update_attributes(title: title)
      unless (new_variant_id_array).empty?
        new_variant_id_array.each do |new_variant_id|
          ext_variant = ShopifyAPI::Variant.find(new_variant_id)
          local_product.variants.new(shopify_variant_id: new_variant_id,
                                     variant_title: ext_variant.title.to_s,
                                     variant_price: ext_variant.price.to_s)
          local_product.save
        end
      end
      local_shopify_variant_id_array.each do |local_shopify_variant_id|
        if ext_shopify_variant_id_array.include? local_shopify_variant_id
          #update
          ext_variant = ShopifyAPI::Variant.find(local_shopify_variant_id)
          local_variant = Variant.find_by(shopify_variant_id: local_shopify_variant_id )
          local_variant.update_attributes(variant_title: ext_variant.title.to_s,
                                          variant_price: ext_variant.price.to_s)
        else
          dead_variant = local_variants.find_by(shopify_variant_id: local_shopify_variant_id)
          dead_variant.destroy
        end
      end
      shop.products.find_by(shopify_product_id: shopify_product_id).delete_collects
      shop.seed_collects!
    end
  end
end