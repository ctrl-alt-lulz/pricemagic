class AddViewThresholdToPriceTest < ActiveRecord::Migration
  def change
    add_column :price_tests, :view_threshold, :integer
  end
end
