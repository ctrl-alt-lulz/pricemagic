class CreateFakes < ActiveRecord::Migration
  def change
    create_table :fakes do |t|

      t.timestamps null: false
    end
  end
end
