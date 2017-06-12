class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  include ShopifyApp::SessionStorage

  has_many :users

  def latest_access_token
    #gets latest access token
    users.order(created_at: :desc).first.google_access_token
  end
end
