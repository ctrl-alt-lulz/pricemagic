class RemoveShopifyProductIdAndCollectionIdFromCollect < ActiveRecord::Migration
  def change
    add_column :collects, :collection_id, :integer
    add_column :collects, :product_id, :integer
    # remove_column :collects, :shopify_product_id
    remove_column :collects, :shopify_collection_id
    rename_column :collects, :collect_id, :shopify_collect_id
  end
end
