class ApplicationController < ActionController::Base
  include ShopifyApp::LoginProtection
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session,
                       if: Proc.new { |c| c.request.format =~ %r{application/json} }

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
  
  ## FOR Devise / SiteAdmin
  def after_sign_in_path_for(resource)
    admin_root_path
  end
    
  private
  
end