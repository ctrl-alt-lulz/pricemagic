class CreatePriceTest < ActiveRecord::Migration
  def change
    create_table :price_tests do |t|
      t.string :product_id
      t.float :percent_increase
      t.float :percent_decrease
      t.jsonb :price_data

      t.timestamps null: false
    end
    add_index :price_tests, :product_id
  end
end
