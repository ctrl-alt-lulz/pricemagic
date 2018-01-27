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


  def initiate_charge
    @recurring_charge = current_shop.recurring_charges.new(recurring_charge_params)
    if @recurring_charge.save
      respond_to do |format|
        format.html { render :text => "<script>window.top.location.href='#{ @recurring_charge.confirmation_url }';</script>" }
        format.json { render json: { success: true, redirect_url: @recurring_charge.confirmation_url }, status: 201 }
      end
    else
      respond_to do |format|
        format.html { redirect_to billings_path, notice: 'Something went wrong' }
        format.json { render json: { success: false, errors: @recurring_charge.errors.full_messages }, status: 201 }
      end
    end
  end

  private

  def recurring_charge_params
    { shop_id: current_shop.id }
  end

end