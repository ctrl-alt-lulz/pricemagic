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

# Assets / views
gem "react_on_rails", "~> 7"
gem 'kaminari'

# Services
gem 'shopify_app'
gem 'sidekiq'
gem 'sidekiq-scheduler', '~> 2.1.7'
gem 'google-api-client', '~> 0.11'
gem "activerecord-import", ">= 0.2.0"

group :development, :test do
  gem 'byebug'
  gem 'dotenv-rails'
  gem 'pry-rails'
end

group :development do
  gem 'spring'

  # thin server, better than default webrick, use in conjunction with ngrok
  gem 'thin'
end

group :production do
	# required to deploy to heroku
	gem 'rails_12factor'
end
