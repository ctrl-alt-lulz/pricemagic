class WebhooksController < ApplicationController
  before_filter :verify_webhook, :except => 'verify_webhook'

  def index
  end

  def create
  end

  def product_new
    data = ActiveSupport::JSON.decode(request.body.read)
    puts data
    puts '*'* 500
    new_product = Product.new(title: params[:title], shopify_product_id: params[:id],
                              product_type: params[:product_type], tags: params[:tags],
                              shop_id: 1)
    new_product.save
    head :ok
  end

  def product_delete
    data = ActiveSupport::JSON.decode(request.body.read)
    puts data
    puts '*'* 500
    ::Product.find_by(shopify_product_id: params[:id]).destroy
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
