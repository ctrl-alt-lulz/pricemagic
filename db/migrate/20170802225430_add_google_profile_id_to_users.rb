class AddGoogleProfileIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :google_profile_id, :string
  end
end
