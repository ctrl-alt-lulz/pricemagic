class RecurringChargesController < ShopifyApp::AuthenticatedController
  
  def index
    @recurring_charges_info = ShopifyAPI::RecurringApplicationCharge.current
    @recurring_charges = current_shop.charges
    #<%= @reccuring_charges_info.nil? ? "no charges" : @recurring_charges_info %>
  end
  
  def create
    #ShopifyAPI::RecurringApplicationCharge.current.destroy
    if ShopifyAPI::RecurringApplicationCharge.current
      puts ShopifyAPI::RecurringApplicationCharge.current.inspect
      puts 'Too current...'
      redirect_to root_url
    else 
      @recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.new(
        name: "Paid Price Test Subscription",
        price: 19.99,
        return_url: "https:\/\/price-magic-bytesize.c9users.io\/recurring_charges_activate", ## TODO set up an environment variable
        test: true,
        terms: "$19.99 per month for up to 50 tests"
      )
  
      if @recurring_application_charge.save && RecurringCharge.create(recurring_charge_params).persisted?
        puts '*'*50
        puts 'Success'
        puts recurring_charge_params.inspect
        respond_to do |format|
          format.html { redirect_to @recurring_application_charge.confirmation_url }
          format.json { render json: { success: true, redirect_url: @recurring_application_charge.confirmation_url }, status: 201 }
        end
      else
        puts '*'*50
        puts 'Failed'
        puts @recurring_application_charge.attributes.inspect
        puts recurring_charge_params
        puts @recurring_application_charge.errors.inspect
        puts '*'*50
        respond_to do |format|
          format.html { redirect_to @recurring_application_charge.confirmation_url, notice: 'Something went wrong' }
          format.json { render json: { success: false, errors: @recurring_application_charge.errors.full_messages }, status: 201 }
        end
      end
    end
  end
  
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
    # recurring_application_charge.attributes
    { shop_id: current_shop.id }.merge(charge_data: @recurring_application_charge.attributes)
  end

end
