class ChangeNameOfColumnOnPriceTest < ActiveRecord::Migration
  def up
    rename_column :price_tests, :product_id, :shopify_product_id
    add_column :price_tests, :product_id, :integer
  end
  
  def down
    remove_column :price_tests, :product_id
    rename_column :price_tests, :shopify_product_id, :product_id
  end
end
