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
  after_create :create_webhooks, :seed_all_product_info

  ## TODO set up metrics to use  by default
  ## ike with Product
  def trial?
    !price_tests.any?
  end
  
  def stop_price_tests!
    StopPriceTestsWorker.perform_async(id)
  end
  
  def has_subscription?
    recurring_charges.last.nil? ? false : recurring_charges.last.try(:active?)
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
    users.first.google_profile_id
  end

  def with_shopify!
    session = ShopifyAPI::Session.new(shopify_domain, shopify_token)
    ShopifyAPI::Base.activate_session(session)
  end
  
  private
  
  def create_webhooks
    webhook = {
      topic: 'products/create',
      address: Rails.configuration.public_url + 'webhooks/products/new',
      format: 'json'
    }
    ShopifyAPI::Webhook.create(webhook)
    webhook = {
      topic: 'products/delete',
      address: Rails.configuration.public_url + 'webhooks/products/delete',
      format: 'json'
    }
    ShopifyAPI::Webhook.create(webhook)
    webhook = {
      topic: 'products/update',
      address: Rails.configuration.public_url + 'webhooks/products/update',
      format: 'json'
    }
    ShopifyAPI::Webhook.create(webhook)
    webhook = {
      topic: 'collections/create',
      address: Rails.configuration.public_url + 'webhooks/collections/create',
      format: 'json'
    }
    ShopifyAPI::Webhook.create(webhook)
    webhook = {
      topic: 'collections/delete',
      address: Rails.configuration.public_url + 'webhooks/collections/delete',
      format: 'json'
    }
    ShopifyAPI::Webhook.create(webhook)
    webhook = {
      topic: 'collections/update',
      address: Rails.configuration.public_url + 'webhooks/collections/update',
      format: 'json'
    }
    ShopifyAPI::Webhook.create(webhook)
    webhook = {
      topic: 'app/uninstalled',
      address: Rails.configuration.public_url + 'webhooks/app/uninstalled',
      format: 'json'
    }
    ShopifyAPI::Webhook.create(webhook)
  end

  def seed_all_product_info
    SingleShopSeedProductsAndVariantsWorker.perform_async(id)
  end
end
