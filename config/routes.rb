Rails.application.routes.draw do
  mount ShopifyApp::Engine, at: '/'
  root :to => 'dashboard#index'
  get 'google_auth', to: 'google_auth#new'
  get 'oauth2callback', to: 'google_auth#callback'
  get 'analytics', to: 'google_auth#analytics'
  resources :dashboard, :products, :price_tests
end
