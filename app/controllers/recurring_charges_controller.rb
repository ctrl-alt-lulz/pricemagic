class RecurringChargesController < ShopifyApp::AuthenticatedController
  
  def create
    if ShopifyAPI::RecurringApplicationCharge.current
      puts ShopifyAPI::RecurringApplicationCharge.current.inspect
      ShopifyAPI::RecurringApplicationCharge.current.destroy ## TODO set up a way to manage payments
      puts 'Too current...'
      redirect_to root_url
    else 
      recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.new(
        name: "Paid Price Test Subscription",
        price: 19.99,
        return_url: "https:\/\/price-magic-bytesize.c9users.io\/recurring_charges/activate", ## TODO set up an environment variable
        test: true,
        terms: "$19.99 per month for up to 50 tests"
      )
  
      if recurring_application_charge.save
        respond_to do |format|
          format.html { redirect_to recurring_application_charge.confirmation_url }
          format.json { render json: { success: true, redirect_url: recurring_application_charge.confirmation_url }, status: 201 }
        end
      else
        puts '*'*50
        puts recurring_application_charge.errors.inspect
        puts '*'*50
        respond_to do |format|
          format.html { redirect_to recurring_application_charge.confirmation_url, notice: 'Something went wrong' }
          format.json { render json: { success: false, errors: recurring_application_charge.errors.full_messages }, status: 201 }
        end
      end
    end
  end
  
  def show
    recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.find(params[:charge_id])
    if recurring_application_charge.status.eql? "accepted"
      recurring_application_charge.activate
      flash[:notice] = "Successfully Activated"
      redirect_to root_url
    else 
      flash[:warning] = "Did Not Activated"
      redirect_to root_url
    end
  end

end
