ShopifyApp.configure do |config|
  config.api_key = Rails.configuration.shopify_api_key
  config.secret = Rails.configuration.shopify_secret
  config.scope = "read_orders, read_products, write_products"
  config.embedded_app = true
  config.webhooks = [
    { topic: 'products/create', address: Rails.configuration.public_url + 'webhooks/products/new', format: 'json'},
    { topic: 'products/delete', address: Rails.configuration.public_url + 'webhooks/products/delete', format: 'json'},
    { topic: 'products/update', address: Rails.configuration.public_url + 'webhooks/products/update', format: 'json' },
    { topic: 'collections/create', address: Rails.configuration.public_url + 'webhooks/collections/create', format: 'json'},
    { topic: 'collections/delete', address: Rails.configuration.public_url + 'webhooks/collections/delete', format: 'json'},
    { topic: 'collections/update', address: Rails.configuration.public_url + 'webhooks/collections/update', format: 'json'},
    { topic: 'app/uninstalled', address: Rails.configuration.public_url + 'webhooks/app/uninstalled', format: 'json'}
  ]
end
