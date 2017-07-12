class DashboardController < ShopifyApp::AuthenticatedController
  # GET /admin
  # GET /admin.json
  def index
    @product_count = ShopifyAPI::Product.count
    @products = ShopifyAPI::Product.find(:all, :params => {:limit => 150})
    paginate
    collection_titles
  end

  def show
  end

  
  def search(phrase, term)
    return !!(phrase=~ /#{term}/i)
  end
  
  #params[:term]
  def search_title
    collection_titles
    @matches = []
    @products = ShopifyAPI::Product.find(:all, :params => {:limit => 150})
    @products.each_with_index do |p,index|
       @matches << @products[index.to_i] if search(p.title, params[:term]) 
    end
    @products = @matches
    paginate
  end
  
  def get_collection
    collection_titles
    @matches = []
    @products = ShopifyAPI::Product.find(:all, :params => {:limit => 150})
    @products.each_with_index do |p,index|
       @matches << @products[index.to_i] if search(p.title, params[:collection]) 
    end
    @products = @matches
    paginate
  end
  
  private 
  
  def paginate
    @paginatable_array = Kaminari.paginate_array(@products).page(params[:page]).per(10)
  end
  
  def collection_titles
    @collection_titles = []
    @scollection = ShopifyAPI::SmartCollection.find(:all)
    @ccollection = ShopifyAPI::CustomCollection.find(:all)
    @scollection.each { |c| @collection_titles << c.title}
    @ccollection.each { |c| @collection_titles << c.title}
  end
end
