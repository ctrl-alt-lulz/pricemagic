class AddPricePointsToPriceTest < ActiveRecord::Migration
  def change
    add_column :price_tests, :price_points, :integer, default: 0
  end
end
