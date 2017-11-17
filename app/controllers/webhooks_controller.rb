class WebhooksController < ShopifyApp::AuthenticatedController
  
  def create 
    puts '*'*50
    puts "We're HERE!"
    puts '*'*50
    
    verify_webhook(request)

    # Send back a 200 OK response
    head :ok
  end
  
  def receive
    # head :ok
    # puts params.inspect
    # puts 'webhook'
    # SingleShopSeedProductsAndVariantsWorker.perform_async(1)
    # respond_to do |format|
    #   format.json { render json: { success: true }, status: 200 }
    # end
    puts '*'*50
    puts "We're HERE!"
    puts '*'*50
    
    verify_webhook(request)

    # Send back a 200 OK response
    SiteAdmin.create(email: 'test@me.com', password: 'password', password_confirmation: 'password')
    head :ok
  end
   
  def verify_webhook(request)
    header_hmac = request.headers["HTTP_X_SHOPIFY_HMAC_SHA256"]
    digest = OpenSSL::Digest.new("sha256")
    request.body.rewind
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, SHARED_SECRET, request.body.read)).strip

    puts "header hmac: #{header_hmac}"
    puts "calculated hmac: #{calculated_hmac}"

    puts "Verified:#{ActiveSupport::SecurityUtils.secure_compare(calculated_hmac, header_hmac)}"
  end
  private
  
end
