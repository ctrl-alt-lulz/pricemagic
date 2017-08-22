module PriceTestExtShopifyMethods
  def ext_shopify_variants
   ext_shopify_product.variants
  end
  
  def revert_to_original_price!
    ## TODO make this similar to #apply_current_test_price_async!
  end
  
  def revert_to_original_price!
    ext_shopify_variants.each do |variant|
      variant.price = price_data[variant.id.to_s]['original_price']
    end
    ext_shopify_product.save
  end
  
  def apply_current_test_price_async!
    UpdateCurrentPriceWorker.perform_in(1.second, id)
  end
  
  def apply_current_test_price!
    ext_shopify_variants.each do |variant|
      variant.price = price_data[variant.id.to_s]['current_test_price']
    end
    ext_shopify_product.save
  end
  
  def ext_shopify_product
    @ext_shopify_product ||= ShopifyAPI::Product.find(self.product.shopify_product_id)
  end
end