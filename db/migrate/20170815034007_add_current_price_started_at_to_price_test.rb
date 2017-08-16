class AddCurrentPriceStartedAtToPriceTest < ActiveRecord::Migration
  def change
    add_column :price_tests, :current_price_started_at, :datetime
  end
end
