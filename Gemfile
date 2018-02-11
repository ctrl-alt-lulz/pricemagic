source 'https://rubygems.org'

ruby '2.3.1'

# Core
gem 'rails', '4.2.6'
gem 'pg', '~> 0.15'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'puma'
gem 'web-console', '~> 2.0'
gem 'mini_racer', platforms: :ruby
gem 'devise'
gem 'administrate'

# Assets / views
gem 'kaminari'

# Services
gem 'shopify_app'
gem 'sidekiq'
gem 'sidekiq-scheduler', '~> 2.1.7'
gem 'google-api-client', '~> 0.11'
gem 'activerecord-import', '>= 0.2.0'
gem 'webpacker', '~> 2.0'
gem 'rack-cors', :require => 'rack/cors'
gem 'aws-sdk-ses', '~> 1'

group :development, :test do
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'pry-rails'
  gem 'factory_girl'
  gem 'faker'
  gem 'rspec-rails'
end

group :development do
  gem 'spring'
  gem 'bullet'
  # thin server, better than default webrick, use in conjunction with ngrok
  gem 'thin'
end

group :production do
	# required to deploy to heroku
	gem 'rails_12factor'
	gem 'redis'
end

group :test do
  gem 'shoulda-matchers'
  gem 'database_cleaner'
end
