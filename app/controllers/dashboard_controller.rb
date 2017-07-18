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
    # session.delete :collections
    
    ## TODO Alex research doing this with cookies to minimize external requests
    ## cookies[:login] = { :value => "XJ-122", :expires => 1.hour.from_now }
    unless session[:collections].present?
      session[:collections] = ShopifyAPI::SmartCollection.find(:all).map{|sc| OpenStruct.new({ title: sc.title, id: sc.id }) }  + ShopifyAPI::CustomCollection.find(:all).map{|cc|  OpenStruct.new({ title: cc.title, id: cc.id }) } 
    end
    logger.debug '*'*50
    logger.debug session[:collections].inspect
    logger.debug session[:collections].class.name
    
    @collections = session[:collections]
    
    logger.debug '!'*50
    logger.debug @collections.inspect
    logger.debug @collections.class.name
  end
end
