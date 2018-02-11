class ProductsController < ShopifyApp::AuthenticatedController
  before_filter :convert_percent_to_float, only: :update
  before_filter :instantiate_price_test, only: [:show, :index]
  before_filter :define_collection, only: :show
  before_filter :define_product, only: [:show, :update]
  before_filter :confirm_billing

  def index
    @shop ||= current_shop
    @run_walkthrough ||= @shop.run_walkthrough?
    @collections ||= @shop.collections
    @pt_data ||= @shop.price_tests.where(active: true).map {|pt| [pt.product_id, pt.completion_percentage]}.to_h
    @products ||= map_products(@shop.products.includes(:price_tests).order('title ASC'))
    if params[:term]
      @products = map_products(@shop.products.includes(:price_tests).where('title iLIKE ?', '%' + params[:term] + '%'))
      if params[:collection].present?
        @products = map_products(@collections.find(params[:collection]).products.includes(:price_tests).where('title iLIKE ?', '%' + params[:term] + '%'))
      end
    end
    #@products = current_shop.products.search(params) ## TODO self.search inside Product.rb
    respond_to do |format|
      format.html # default html response
      format.json { render json: @products }
    end
  end
  
  def show
    @price_test_data = PriceTest.where(product_id: @product.id).last
    @variants = @price_test_data.try(:product).try(:variants)
    @variants = @variants.map(&:variant_title) if @variants 
    @unitPriceValueHash = @product.variant_unit_cost_hash
    @percent_increase = ''
    @percent_decrease = ''
    @view_threshold = ''
    @ending_digits = 0.99
    @price_points = 1
    if @price_test_data
      @variant_plot_data = @price_test_data.try(:final_plot).try(:first)
      @plot_count = @price_test_data.try(:final_plot).try(:length)
      @final_plot = @price_test_data.try(:final_plot)
      @all_data = @price_test_data.try(:final_plot).try(:flatten)
      @google_analytics_data = @product.most_recent_metrics
      @price = @product.first_variant_price
      @current_shop = current_shop
      @revenue_hash = @price_test_data.revenue_hash
      @profit_hash = @price_test_data.profit_hash
      @profit_per_view_hash = @price_test_data.profit_per_view_hash
      @revenue_per_view_hash = @price_test_data.revenue_per_view_hash
      @percent_increase = ((@price_test_data.percent_increase - 1)*100).round(0)
      @percent_decrease = ((1-@price_test_data.percent_decrease)*100).round(0)
      @view_threshold = @price_test_data.view_threshold
      @ending_digits = @price_test_data.ending_digits
      @price_points = @price_test_data.price_points
    end
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

  def confirm_billing
    initiate_charge unless current_charge?
  end
  
  private

  def define_product
     @product = current_shop.products.find(params[:id])
  end
   
  def convert_percent_to_float
    params[:percent_increase] ||= 0
    @percent_increase = 1+(params[:percent_increase].to_f)/100
  end

  def instantiate_price_test
    @price_test = current_shop.price_tests.new
  end
  
  def define_collection
    @collections ||=  current_shop.products.find(params[:id]).collections.map(&:title)
  end

  def is_active(active)
    active ? "Running" : "Inactive"
  end

  def map_products(products)
    products.pluck(:id, :title, :active).map do |item|
      {
        id: item[0],
        title: item[1],
        active: is_active(item[2]),
        price_test_completion_percentage: nil2zero(@pt_data[item[0]])
      }
    end
  end

  def nil2zero(value)
    value.nil? ? 0.0 : value
  end
end
