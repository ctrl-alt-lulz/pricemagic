class ProductsController < ShopifyApp::AuthenticatedController
  def show
    @product = ShopifyAPI::Product.find(params[:id])
    #model.find http request has id
  end
end
