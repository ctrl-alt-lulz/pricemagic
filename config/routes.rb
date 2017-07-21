Rails.application.routes.draw do
  mount ShopifyApp::Engine, at: '/'
  root :to => 'dashboard#index'
  get 'google_auth', to: 'google_auth#new'
  get 'oauth2callback', to: 'google_auth#callback'
  get 'analytics', to: 'google_auth#analytics'
  get 'search_title', to: 'dashboard#search_title'
  get 'get_collection', to: 'dashboard#get_collection'
  resources :dashboard, :products, :price_tests
end
