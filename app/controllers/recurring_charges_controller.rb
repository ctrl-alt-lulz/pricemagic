class RecurringChargesController < ShopifyApp::AuthenticatedController
  
  def create
    puts '*'*50
    puts 'IN RecurringChargesController'
    unless ShopifyAPI::RecurringApplicationCharge.current ## TODO redirect back to where they came from
      recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.new(
        name: "Paid Price Test Subscription",
        price: 19.99,
        return_url: "https:\/\/price-magic-bytesize.c9users.io\/recurring_charges/activate", ## TODO set up an environment variable
        test: true,
        terms: "$19.99 per month for up to 50 tests")
  
      puts recurring_application_charge.inspect
  
      if recurring_application_charge.save
        # @tokens[:confirmation_url] = recurring_application_charge.confirmation_url
        
        puts '!'*50
        puts 'After save'
        puts recurring_application_charge.inspect
        puts '!'*50
        redirect_to recurring_application_charge.confirmation_url
      end
    end
  end
  
  def activate
    # recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.find(request.params['charge_id'])
    # recurring_application_charge.status == "accepted" ? recurring_application_charge.activate : redirect(bulk_edit_url)
  
    # create_order_webhook
    # redirect bulk_edit_url
  end

end
