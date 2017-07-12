class DashboardController < ShopifyApp::AuthenticatedController
before_action :collection_titles, only: [:index, :search_title, :get_collection]
before_action :products, only: [:index, :search_title, :get_collection]

  def index
    @product_count = ShopifyAPI::Product.count
    paginate
  end

  def show
  end
  
  def search_title
    @matches = []
    @products.each_with_index do |p,index|
       @matches << @products[index.to_i] if search(p.title, params[:term]) 
    end
    @products = @matches
    paginate
  end
  
  def get_collection
    ## TODO make this find products in collection
    @matches = []
    @products.each_with_index do |p,index|
       @matches << @products[index.to_i] if search(p.title, params[:collection]) 
    end
    @products = @matches
    paginate
  end
  
  private 
  
  def search(phrase, term)
    return !!(phrase=~ /#{term}/i)
  end
  
  def products
    @products = ShopifyAPI::Product.find(:all, :params => {:limit => 150})
  end
  
  def paginate
    @paginatable_array = Kaminari.paginate_array(@products).page(params[:page]).per(10)
  end
  
  def collection_titles
    @collection_titles = []
    @collection_ids = []
    @scollection = ShopifyAPI::SmartCollection.find(:all)
    @ccollection = ShopifyAPI::CustomCollection.find(:all)
    @scollection.each { |c| @collection_titles << c.title;  @collection_ids << c.id}
    @ccollection.each { |c| @collection_titles << c.title;  @collection_ids << c.id}
  end
end
