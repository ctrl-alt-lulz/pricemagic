class AddShopIdToCollects < ActiveRecord::Migration
  def change
    add_column :collects, :shop_id, :integer
  end
end
