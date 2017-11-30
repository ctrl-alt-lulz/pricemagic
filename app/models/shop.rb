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
  after_create :seed_all_product_info

  ## TODO set up metrics to use  by default
  ## ike with Product
  def trial?
    !price_tests.any?
  end
  
  def stop_price_tests!
    StopPriceTestsWorker.perform_async(id)
  end
  
  def has_subscription?
    if ShopifyAPI::RecurringApplicationCharge.current.nil?
      false
    else
      ShopifyAPI::RecurringApplicationCharge.current.attributes['status'] == 'active'
    end
  end
  
  def latest_metric
    metrics.last
  end

  def latest_access_token
    return unless users.with_access_token.any?
    users.with_access_token.first.google_access_token
  end
  
  def latest_refresh_token
    users.with_refresh_token.first.google_refresh_token
  end
  
  def google_profile_id
    users.last.try(:google_profile_id)
  end

  def with_shopify!
    session = ShopifyAPI::Session.new(shopify_domain, shopify_token)
    ShopifyAPI::Base.activate_session(session)
  end

  def run_walkthrough?
    price_tests.count == 0
  end

  private

  def seed_all_product_info
    SingleShopSeedProductsAndVariantsWorker.perform_async(id)
  end
end
