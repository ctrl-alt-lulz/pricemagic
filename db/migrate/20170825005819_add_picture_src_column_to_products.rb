class AddPictureSrcColumnToProducts < ActiveRecord::Migration
  def change
    add_column :products, :main_image_src, :string
  end
end
