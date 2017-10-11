class AddUnitCostToVariant < ActiveRecord::Migration
  def change
    add_column :variants, :unit_cost, :float
  end
end
