class AddCollectionDataToProducts < ActiveRecord::Migration
  def change
    add_column :products, :shopify_collection_data, :jsonb
  end
end
