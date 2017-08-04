class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  include ShopifyApp::SessionStorage

  has_many :users, dependent: :destroy
  has_many :metrics, dependent: :destroy

  def latest_access_token
    users.order(updated_at: :desc).where.not(google_access_token: nil).first.google_access_token
  end
  
  def latest_refresh_token
    users.order(updated_at: :desc).where.not(google_refresh_token: nil).first.google_refresh_token
  end
  
  def google_profile_id
    users.order(updated_at: :desc).first.google_profile_id
  end

  def with_shopify!
    session = ShopifyAPI::Session.new(shopify_domain, shopify_token)
    ShopifyAPI::Base.activate_session(session)
  end
end
