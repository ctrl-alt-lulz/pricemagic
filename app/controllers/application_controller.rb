class ApplicationController < ActionController::Base
  include ShopifyApp::LoginProtection
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def base_url
  	Rails.configuration.public_url
  end

  def current_shop
    @shop ||= Shop.where(shopify_domain: session['shopify_domain']).first
  end
  
  def redirect_to_root
    redirect_to root_url
  end
  
  def current_charge?
    !!ShopifyAPI::RecurringApplicationCharge.current
  end
end