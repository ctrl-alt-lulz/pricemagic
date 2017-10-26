class ProductsController < ShopifyApp::AuthenticatedController
  before_filter :convert_percent_to_float, only: :update
  before_filter :instantiate_price_test, only: [:show, :index]
  before_filter :define_collection, only: :show
  before_filter :define_product, only: [:show, :update]

  def index
    @collections = Collection.all
    if params[:term].present?
      @products = Product.where('title iLIKE ?', '%' + params[:term] + '%')
    elsif params[:collection]
      @products = Collection.find(params[:collection]).products
    else
      @products = Product.all
    end
    @products = @products.includes(:price_tests, :variants)
    respond_to do |format|
      format.html # default html response
      format.json { render json: @products }
    end
  end
  
  def show
    @price_test_data = PriceTest.where(product_id: @product.id).last
    @variant_plot_data = @price_test_data.try(:final_plot).try(:first)
    @plot_count = @price_test_data.try(:final_plot).try(:length)
    @final_plot = @price_test_data.try(:final_plot)
    @all_data = @price_test_data.try(:final_plot).try(:flatten)
    @google_analytics_data = @product.most_recent_metrics
    @price = @product.first_variant_price
    @unitPriceValueHash = @product.variant_unit_cost_hash
    @current_shop = current_shop
    respond_to do |format|
      format.html # default html response
      format.json { render json: @product }
    end
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
    @collections ||=  Product.find(params[:id]).collections.map(&:title)
  end
end
