class AddEndingDigitsToPriceTest < ActiveRecord::Migration
  def change
    add_column :price_tests, :ending_digits, :float, default: 0.99
  end
end
