class CreateCollects < ActiveRecord::Migration
  def change
    create_table :collects do |t|
      t.string :shopify_product_id
      t.string :shopify_collection_id
      t.string :position
      t.string :collect_id
      
      t.timestamps null: false
    end
  end
end
