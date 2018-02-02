class AddAffiliateFlagToShop < ActiveRecord::Migration
  def change
    add_column :shops, :affiliate, :boolean, default: false
  end
end
