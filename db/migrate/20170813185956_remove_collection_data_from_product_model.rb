class RemoveCollectionDataFromProductModel < ActiveRecord::Migration
  def change
    remove_column :products, :shopify_collection_data
  end
end
