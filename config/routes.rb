Rails.application.routes.draw do
  get 'google_auth', to: 'google_auth#new'
  get 'oauth2callback', to: 'google_auth#callback'
  get 'analytics', to: 'google_auth#analytics'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  mount ShopifyApp::Engine, at: '/'
  
  root :to => 'dashboard#index'
  resources :dashboard, :products

  # the ProxyController will pick up ApplicationProxy requests
  # and forward valid ones on to the pages#show action
  get 'proxy' => 'proxy#index'
end
