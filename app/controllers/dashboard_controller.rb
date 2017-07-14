class DashboardController < ShopifyApp::AuthenticatedController
  before_action :define_collections, only: [:index]

  def index
    if params[:collection] || params[:term]
      @products = ShopifyAPI::Product.where(collection_id: params[:collection], title: params[:term])
    else
      @products = ShopifyAPI::Product.find(:all, :params => {:limit => 150})
    end
    @paginatable_array = Kaminari.paginate_array(@products).page(params[:page]).per(10)
  end
  
  private 
  
  def define_collections
    ## TODO Alex research doing this with cookies to minimize external requests
    # unless cookies[:collections].present?
    #   cookies[:collections] = ShopifyAPI::SmartCollection.find(:all) + ShopifyAPI::CustomCollection.find(:all)
    # end
    # @collections = cookies[:collections]
    @collections ||= ShopifyAPI::SmartCollection.find(:all) + ShopifyAPI::CustomCollection.find(:all)
  end
end
