class AddAdminToSiteAdmins < ActiveRecord::Migration
  def change
    add_column :site_admins, :admin, :boolean
  end
end
