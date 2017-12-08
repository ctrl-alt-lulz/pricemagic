class UpdateProductWorker
  include Sidekiq::Worker
  sidekiq_options retry: 15

  def perform(params, id)
    shop = Shop.find(id)
    local_product = shop.products.find_by(shopify_product_id: params[:variants].first[:product_id].to_s)
    unless local_product.price_tests.last.active
      ext_shopify_variant_id_array =  params[:variants].map{|variant| variant[:id].to_s}
      shop.with_shopify!
      local_variants  = shop.products.find_by(shopify_product_id: params[:id]).variants
      local_shopify_variant_id_array = local_variants.map{|variant| variant.shopify_variant_id.to_s }
      new_variant_id_array = ext_shopify_variant_id_array - local_shopify_variant_id_array
      local_product.update_attributes(title: params[:title])
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
      shop.products.find_by(shopify_product_id: params[:id]).delete_collects
      shop.seed_collects!
    end
  end
end