class AddEmailToShop < ActiveRecord::Migration
  def change
    add_column :shops, :shop_email, :string
  end
end
