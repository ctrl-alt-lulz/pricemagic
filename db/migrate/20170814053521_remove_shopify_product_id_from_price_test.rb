class RemoveShopifyProductIdFromPriceTest < ActiveRecord::Migration
  def change
    remove_column :price_tests, :shopify_product_id
  end
end
