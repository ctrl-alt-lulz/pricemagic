class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  include ShopifyApp::SessionStorage
  include ShopifySeeds

  has_many :users, -> {order(updated_at: :desc)}, dependent: :destroy
  has_many :metrics, -> { order(created_at: :asc)}, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :price_tests, through: :products
  has_many :charges
  has_many :recurring_charges
  
  has_many :collects, through: :products, dependent: :destroy
  has_many :collections, ->{ uniq }, through: :collects, dependent: :destroy
  
  validates :shopify_domain, presence: true
  validates :shopify_token, presence: true
  ## TODO set up metrics to use  by default
  ## ike with Product
  def trial?
    !price_tests.any?
  end
  
  def has_subscription?
    ## TODO make this lookup to shopify each time
    ## TODO set up association locally and manage with shopify
    true
  end
  
  def latest_metric
    metrics.last
  end

  def latest_access_token
    users.with_access_token.first.google_access_token
  end
  
  def latest_refresh_token
    users.with_refresh_token.first.google_refresh_token
  end
  
  def google_profile_id
    users.first.google_profile_id
  end

  def with_shopify!
    session = ShopifyAPI::Session.new(shopify_domain, shopify_token)
    ShopifyAPI::Base.activate_session(session)
  end
end
