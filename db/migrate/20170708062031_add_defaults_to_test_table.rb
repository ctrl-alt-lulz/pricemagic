class AddDefaultsToTestTable < ActiveRecord::Migration
  def up
    change_column :price_tests, :percent_increase, :float, default: 0
    change_column :price_tests, :percent_decrease, :float, default: 0
  end

  def down
    change_column :price_tests, :percent_increase, :float, default: nil
    change_column :price_tests, :percent_decrease, :float, default: nil
  end
end
