class WebhooksController < ApplicationController
  before_filter :verify_webhook, :except => 'verify_webhook'

  def product_new
    head :ok
    new_product = shop.products.new(title: params[:title], shopify_product_id: params[:id],
                              product_type: params[:product_type], tags: params[:tags],
                              shop_id: shop.id)
    new_product.save
    shop.seed_collects!
  end

  def product_update
    head :ok
    ext_shopify_variant_id_array =  params[:variants].map{|variant| variant[:id].to_s}
    shop.with_shopify!
    local_variants  = shop.products.find_by(shopify_product_id: params[:id]).variants
    local_shopify_variant_id_array = local_variants.map{|variant| variant.shopify_variant_id.to_s }
    new_variant_id_array = ext_shopify_variant_id_array - local_shopify_variant_id_array
    unless (new_variant_id_array).empty?
      new_variant_id_array.each do |new_variant_id|
        ext_variant = ShopifyAPI::Variant.find(new_variant_id)
        local_product = shop.products.find_by(shopify_product_id: params[:variants].first[:product_id].to_s)
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
        local_variant.save
      else
       dead_variant = local_variants.find_by(shopify_variant_id: local_shopify_variant_id)
       dead_variant.destroy
      end
    end
    shop.products.find_by(shopify_product_id: params[:id]).delete_collects
    shop.seed_collects!
  end

  def product_delete
    head :ok
    shop.products.find_by(shopify_product_id: params[:id]).destroy
  end

  def collection_delete
    head :ok
    shop.collections.find_by(shopify_collection_id: params[:id].to_s).destroy
  end

  def collection_create
    head :ok
    shop.seed_collections!
    shop.seed_collects!
  end

  def collection_update
    head :ok
  end

  private

  def verify_webhook
    data = request.body.read.to_s
    hmac_header = request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
    digest  = OpenSSL::Digest.new('sha256')
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, ENV['SHOPIFY_SECRET_KEY'], data)).strip
    unless calculated_hmac == hmac_header
      head :unauthorized
    end
    request.body.rewind
  end

  def shop
    Shop.where(shopify_domain: request.headers['X-Shopify-Shop-Domain']).first
  end
end
