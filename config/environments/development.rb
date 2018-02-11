Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # this will be used to serve JavaScript assets
  # using Shopify's Scripttags manager
  # (configured in /config/initializers/shopify_app.rb)
  # and also by ApplicationController
  config.public_url = ENV['NGROK_PUBLIC_URL']

  # shopify app creds
  config.shopify_api_key = ENV['DEV_SHOPIFY_PUBLIC_KEY']
  config.shopify_secret = ENV['DEV_SHOPIFY_SECRET_KEY']

  config.action_mailer.default_url_options = { host: 'price-magic-bytesize.c9users.io' }
  config.action_mailer.perform_deliveries = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :address => "email-smtp.us-west-2.amazonaws.com",
    :port => 587,
    :user_name => ENV["SES_SMTP_USERNAME"], #Your SMTP user
    :password => ENV["SES_SMTP_PASSWORD"], #Your SMTP password
    :authentication => :login,
    :enable_starttls_auto => true
  }
  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Do care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  $stdout.sync = true

end

