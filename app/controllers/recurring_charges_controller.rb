class RecurringChargesController < ShopifyApp::AuthenticatedController
  before_action :redirect_to_root, if: :current_charge?, only: :create
  
  def index
    @recurring_charges_info = ShopifyAPI::RecurringApplicationCharge.current
    @recurring_charges = current_shop.charges
  end
  
  def create
    @recurring_charge = RecurringCharge.new(recurring_charge_params)
    if @recurring_charge.save
      respond_to do |format|
        format.html { redirect_to @recurring_charge.confirmation_url }
        format.json { render json: { success: true, redirect_url: @recurring_charge.confirmation_url }, status: 201 }
      end
    else
      respond_to do |format|
        format.html { redirect_to @recurring_charge.confirmation_url, notice: 'Something went wrong' }
        format.json { render json: { success: false, errors: @recurring_charge.errors.full_messages }, status: 201 }
      end
    end
  end
  
  ## TODO handle this in the model so it looks like a typical rails controller
  ## with just @recurring_charge = RecurringCharge.find(params[:charge_id)
  ## @recurring_charge.update_attributes(...)
  def update
    recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.find(params[:charge_id])
    local_recurring_charge = RecurringCharge.find_by(shopify_id: params[:charge_id])
    if recurring_application_charge.status.eql? "accepted"
      recurring_application_charge.activate
      local_recurring_charge.update_attributes(charge_data: recurring_application_charge.attributes)
      puts '*'*50
      puts recurring_application_charge.inspect
      puts '*'*50
      flash[:notice] = "Successfully Activated"
      redirect_to root_url
    else 
      flash[:warning] = "Did Not Activated"
      redirect_to root_url
    end
  end
  
  def destroy
    local_recurring_charge = RecurringCharge.find_by(id: params[:id])
    if local_recurring_charge.destroy
      redirect_to recurring_charges_path, notice: "Charge cancelled!"
    else 
      redirect_to recurring_charges_path, warning: "Charge was not cancelled"
    end
  end
  
  private
  
  def recurring_charge_params
    { shop_id: current_shop.id }
  end

end
