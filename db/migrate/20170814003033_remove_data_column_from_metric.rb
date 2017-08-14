class RemoveDataColumnFromMetric < ActiveRecord::Migration
  def change
    remove_column :metrics, :data
  end
end
