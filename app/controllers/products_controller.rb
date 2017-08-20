class ProductsController < ShopifyApp::AuthenticatedController
  before_filter :convert_percent_to_float, only: :update
  before_filter :instantiate_price_test, only: [:show, :index]
  before_filter :define_collection, only: :show
  before_filter :define_product, only: [:show, :update]

  def index
    @collections = Collection.all
    if params[:term]
      @products = Product.where('title iLIKE ?', '%' + params[:term] + '%')
    elsif params[:collection]
      @products = Collection.find(params[:collection]).products
    else
      @products = Product.all
    end
    @paginatable_array = @products.page(params[:page]).per(10)
  end
  
  def show
    @price_test_data = PriceTest.where(product_id: @product.id).last
    @google_analytics_data =  @product.most_recent_metrics
  end

  def update
    @product.variants.each{|variant| variant.price = (variant.price.to_f * @percent_increase); }
    if @product.save
      redirect_to product_path(@product), notice: 'Updated successfully!'
    else
      redirect_to product_path(@product), error: @product.errors.full_messages.join(' ')
    end
  end
  
  private
  
  def define_product
     @product = Product.find(params[:id])
  end
   
  def convert_percent_to_float
    params[:percent_increase] ||= 0
    @percent_increase = 1+(params[:percent_increase].to_f)/100
  end

  def instantiate_price_test
    @price_test = PriceTest.new
  end
  
  def define_collection
    @product = Product.find(params[:id])
    @collections ||=  @product.collections.map(&:title)
  end
end
