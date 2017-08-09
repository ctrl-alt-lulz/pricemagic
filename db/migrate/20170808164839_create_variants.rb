class CreateVariants < ActiveRecord::Migration
  def change
    create_table :variants do |t|
      t.integer :product_id
      t.string :shopify_product_id
      t.string :shopify_variant_id
      t.string :variant_title
      t.string :variant_price

      t.timestamps null: false
    end
  end
end
