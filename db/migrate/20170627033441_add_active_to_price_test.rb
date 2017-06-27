class AddActiveToPriceTest < ActiveRecord::Migration
  def change
    add_column :price_tests, :active, :boolean, default: true
  end
end
