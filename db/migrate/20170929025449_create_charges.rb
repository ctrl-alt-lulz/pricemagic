class CreateCharges < ActiveRecord::Migration
  def change
    create_table :charges do |t|
      t.string :type
      t.integer :shopify_id
      t.integer :shop_id
      t.integer :user_id
      t.jsonb :charge_data

      t.timestamps null: false
    end
  end
end
