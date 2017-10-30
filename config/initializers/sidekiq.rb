Sidekiq.configure_server do |config|
  config.redis = { url:  ENV["HEROKU_REDIS_AQUA_URL"] }
end

Sidekiq.configure_client do |config|
  config.redis = { url:  ENV["HEROKU_REDIS_AQUA_URL"] }
end