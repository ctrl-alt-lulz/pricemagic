class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :google_access_token
      t.integer :shop_id

      t.timestamps null: false
    end
  end
end
