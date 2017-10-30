class AddUnitCostToVariant < ActiveRecord::Migration
  def change
    add_column :variants, :unit_cost, :float, default: 0.0
  end
end
