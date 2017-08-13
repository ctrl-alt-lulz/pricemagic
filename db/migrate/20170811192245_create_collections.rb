class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :title
      t.string :shopify_collection_id
      t.string :collection_type

      t.timestamps null: false
    end
  end
end
