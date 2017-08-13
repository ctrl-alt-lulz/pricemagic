class SplitColumnsOutOnMetric < ActiveRecord::Migration
  def change
    add_column :metrics, :product_id, :integer
    add_column :metrics, :variant_id, :integer
    add_column :metrics, :page_title, :string
    add_column :metrics, :page_revenue, :float    
    add_column :metrics, :page_views, :integer
    add_column :metrics, :page_avg_price, :float
    add_column :metrics, :acquired_at, :datetime
  end
end
