class RevertToOldPriceWorker
  include Sidekiq::Worker
  sidekiq_options retry: 15

  def perform(id, product_id, price_data)
    puts price_data
    shop = Shop.find(id)
    shop.with_shopify!
    @ext_shopify_product ||= ShopifyAPI::Product.find(product_id)
    revert_to_original_price!(price_data)
  end

  def ext_shopify_variants
    @ext_shopify_product.variants
  end

  def revert_to_original_price!(price_data)
    ext_shopify_variants.each do |variant|
      variant.price = price_data[variant.id.to_s]['original_price']
    end
    @ext_shopify_product.save
  end
end