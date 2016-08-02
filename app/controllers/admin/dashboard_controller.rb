class Admin::DashboardController < ShopifyApp::AuthenticatedController
  # GET /admin
  # GET /admin.json
  def index
    @products = ShopifyAPI::Product.find(:all, :params => {:limit => 10})
  end
end
