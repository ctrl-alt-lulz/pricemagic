class ApplicationController < ActionController::Base
  include ShopifyApp::LoginProtection
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def base_url
  	Rails.configuration.public_url
  end

  def current_shop
    Shop.last
    #look up real shop based on sessions
  end
end