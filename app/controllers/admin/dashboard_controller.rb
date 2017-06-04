class Admin::DashboardController < ShopifyApp::AuthenticatedController
  # GET /admin
  # GET /admin.json
  def index
    @product_count = ShopifyAPI::Product.count
    @products = ShopifyAPI::Product.find(:all, :params => {:limit => 10})
  end

  def show
  end
end
