ShopifyApp.configure do |config|
  config.api_key = Rails.configuration.shopify_api_key
  config.secret = Rails.configuration.shopify_secret
  config.scope = "read_orders, read_products"
  config.embedded_app = true
end
