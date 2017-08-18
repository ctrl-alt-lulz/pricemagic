class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  include ShopifyApp::SessionStorage
  include ShopifySeeds

  has_many :users, -> {order(updated_at: :desc)}, dependent: :destroy
  has_many :metrics, -> { order(created_at: :asc)}, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :price_tests, through: :products
  
  has_many :collects, through: :products, dependent: :destroy
  has_many :collections, ->{ uniq }, through: :collects, dependent: :destroy

  ## TODO set up metrics to use  by default
  ## ike with Product
  def latest_metric
    #metrics.order(created_at: :asc).last
    metrics.last
  end

  def latest_access_token
    #users.order(updated_at: :desc).where.not(google_access_token: nil).first.google_access_token
    users.where.not(google_access_token: nil).first.google_access_token
  end
  
  def latest_refresh_token
    #users.order(updated_at: :desc).where.not(google_refresh_token: nil).first.google_refresh_token
    users.where.not(google_refresh_token: nil).first.google_refresh_token
  end
  
  def google_profile_id
    #users.order(updated_at: :desc).first.google_profile_id
    users.first.google_profile_id
  end

  def with_shopify!
    session = ShopifyAPI::Session.new(shopify_domain, shopify_token)
    ShopifyAPI::Base.activate_session(session)
  end
end
