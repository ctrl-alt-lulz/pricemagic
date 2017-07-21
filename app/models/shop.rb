class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  include ShopifyApp::SessionStorage

  has_many :users, dependent: :destroy
  has_many :metrics, dependent: :destroy

  def latest_access_token
    #gets latest access token
    users.order(updated_at: :desc).first.google_access_token
  end

  def with_shopify!
    session = ShopifyAPI::Session.new(shopify_domain, shopify_token)
    ShopifyAPI::Base.activate_session(session)
  end
end
