class RemoveShopifyProductIdFromVariants < ActiveRecord::Migration
  def change
    remove_column :collects, :shopify_product_id
    remove_column :collects, :shopify_collection_id
  end
end
