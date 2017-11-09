require 'sidekiq/web'

Rails.application.routes.draw do
  namespace :admin do
    resources :shops
    resources :site_admins
    resources :charges
    resources :collects
    resources :collections
    resources :metrics
    resources :price_tests
    resources :products
    resources :users
    resources :variants
    resources :recurring_charges

    root to: "shops#index"
    authenticate :site_admin do
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  devise_for :site_admins
  mount ShopifyApp::Engine, at: '/'
  root :to => 'products#index'
  get 'google_auth', to: 'google_auth#new'
  get 'oauth2callback', to: 'google_auth#callback'
  get 'analytics', to: 'google_auth#analytics'
  get 'search_title', to: 'dashboard#search_title'
  get 'get_collection', to: 'dashboard#get_collection'
  get 'seed_products_and_variants', to: 'workers#seed_products_and_variants'
  get 'query_google', to: 'workers#query_google'
  get 'update_price_tests_statuses', to: 'workers#update_price_tests_statuses'
  post 'price_tests/bulk_create', to: 'price_tests#bulk_create', as: 'price_tests_bulk'
  delete 'price_tests/bulk_destroy', to: 'price_tests#bulk_destroy', as: 'price_tests_bulk_destroy'
  delete 'google_auth', to: 'google_auth#destroy', as: 'google_auth_destroy'
  resources :products, :price_tests, :recurring_charges, :variants, :configurations
  
  get 'recurring_charges_activate', to: 'recurring_charges#update', as: 'recurring_charges_activate'
end
