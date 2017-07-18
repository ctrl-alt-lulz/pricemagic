class CreateMetric < ActiveRecord::Migration
  def change
    create_table :metrics do |t|
      t.integer :shop_id
      t.json :data, array: true, default: []
      
      t.timestamps null: false
    end
  end
end
