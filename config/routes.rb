Rails.application.routes.draw do
  mount ShopifyApp::Engine, at: '/'
  root :to => 'products#index'
  get 'google_auth', to: 'google_auth#new'
  get 'oauth2callback', to: 'google_auth#callback'
  get 'analytics', to: 'google_auth#analytics'
  get 'search_title', to: 'dashboard#search_title'
  get 'get_collection', to: 'dashboard#get_collection'
  post 'price_tests/bulk_create', to: 'price_tests#bulk_create', as: 'price_tests_bulk'
  resources :products, :price_tests
end
