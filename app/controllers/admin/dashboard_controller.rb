class Admin::DashboardController < ShopifyApp::AuthenticatedController
  # GET /admin
  # GET /admin.json
  def index
    @hello_world_props = { name: "Stranger" }
  end

  def show
    #get the product by id
    #@product = ShopifyAPI::Product.find(params[:id])

  end
end
