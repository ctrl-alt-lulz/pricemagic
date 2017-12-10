class WebhooksController < ApplicationController
  before_filter :verify_webhook, :except => 'verify_webhook'

  def product_new
    head :ok
    shopify_product_id = params[:id].to_s
    variants = params[:variants]
    product_type = params[:product_type]
    title = params[:title]
    tags = params[:tags]
    variants_2 = params[:variants].map{|variant| variant}
    NewProductWorker.perform_async(shopify_product_id, title, shop.id, product_type, tags, variants, variants_2)
    # new_product = shop.products.new(title: params[:title], shopify_product_id: params[:id],
    #                           product_type: params[:product_type], tags: params[:tags],
    #                           shop_id: shop.id)
    # params[:variants].each do |variant|
    #   new_product.variants.new(shopify_variant_id: variant[:id], variant_title: variant[:title],
    #                            variant_price: variant[:price])
    # end
    # new_product.save
    # shop.seed_collects!
  end

  def product_update
    head :ok
    shopify_product_id = params[:id].to_s
    variants = params[:variants]
    title = params[:title]
    ext_shopify_variant_id_array =  variants.map{|variant| variant[:id].to_s}
    UpdateProductWorker.perform_async(shopify_product_id, title, shop.id, ext_shopify_variant_id_array)
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
    puts params
    local_collection = shop.collections.find_by(shopify_collection_id: params[:id])
    local_collection.update_attributes(title: params[:title])
    shop.seed_collects!
    head :ok
  end

  def app_uninstalled
    head :ok
    StopPriceTestsWorker.perform_async(shop.id)
    shop.recurring_charges.last.delete #make into a worker
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
