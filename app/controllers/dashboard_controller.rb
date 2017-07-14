class DashboardController < ShopifyApp::AuthenticatedController
  before_action :define_collections, only: [:index, :search_title, :get_collection]
  #before_action :define_products, only: [:index, :search_title, :get_collection]

  def index
    if params[:collection]
      @products = ShopifyAPI::Product.where(collection_id: params[:collection])
    else 
      @products = ShopifyAPI::Product.find(:all, :params => {:limit => 150})
    end
    paginate
  end

  def show
  end
  
  def search_title
    @products ||= ShopifyAPI::Product.find(:all, :params => {:limit => 150})
    @matches = []
    @products.each_with_index do |p,index|
       @matches << @products[index.to_i] if search(p.title, params[:term]) 
    end
    @products = @matches
    paginate
  end
  
  private 
  
  def search(phrase, term)
    return !!(phrase=~ /#{term}/i)
  end
  
  def define_products
    @products ||= ShopifyAPI::Product.find(:all, :params => {:limit => 150})
  end
  
  def paginate
    @paginatable_array = Kaminari.paginate_array(@products).page(params[:page]).per(10)
  end
  
  def define_collections
    @collections ||= ShopifyAPI::SmartCollection.find(:all) + ShopifyAPI::CustomCollection.find(:all)
  end
end
