class DashboardController < ShopifyApp::AuthenticatedController
  before_action :define_collections, only: [:index]

  def index
    if params[:term]
      @products = Product.where('title iLIKE ?', '%' + params[:term] + '%')
    elsif params[:collection]
      @products = Collection.find(params[:collection]).products
    else
      @products = Product.all
    end
    @paginatable_array = @products.page(params[:page]).per(10)
  end
  
  private 
  
  def define_collections
    @collections = Collection.all
  end
end
