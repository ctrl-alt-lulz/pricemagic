class Collect < ActiveRecord::Base
  # shopify_product_id --> rely on the product internal your app
  # shopify_collection_id --> rely on the product internal your app
  # shopify_collect_id ## change this name
  belongs_to :product #product_id
  belongs_to :collection #collection_id
  
  # def shopify_product_id
  #   product.shopify_product_id
  # end
  
  # def shopify_collection_id
  #   collection.shopify_collection_id
  # end
end
