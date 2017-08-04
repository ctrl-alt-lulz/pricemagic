class AddRefreshTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :google_refresh_token, :text
  end
end
