class WebhooksController < ApplicationController
  before_filter :verify_webhook, :except => 'verify_webhook'

  def index
  end

  def create
  end

  def product_new
    # data = ActiveSupport::JSON.decode(request.body.read)
    # #puts data
    # puts '*'* 500
    head :ok
  end

  def verify_webhook
    data = request.body.read.to_s
    hmac_header = request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
    digest  = OpenSSL::Digest.new('sha256')
    calculated_hmac = Base64.encode64(OpenSSL::HMAC.digest(digest, ENV['SHOPIFY_SECRET_KEY'], data)).strip
    unless calculated_hmac == hmac_header
      head :unauthorized
    end
    request.body.rewind
  end
  private

end
