class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :title
      t.string :shopify_product_id
      t.string :product_type
      t.string :tags

      t.timestamps null: false
    end
  end
end
