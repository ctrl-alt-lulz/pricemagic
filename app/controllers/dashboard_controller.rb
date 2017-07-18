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
    ## TODO figure out how to get this working so we dont need to wipe it clean 
    ## by deleting each page load
    session.delete :collections
    
    ## TODO Alex research doing this with cookies to minimize external requests
    ## cookies[:login] = { :value => "XJ-122", :expires => 1.hour.from_now }
    unless session[:collections].present?
      session[:collections] = ShopifyAPI::SmartCollection.find(:all) + ShopifyAPI::CustomCollection.find(:all)
    end
  
    @collections = session[:collections]
  end
end
