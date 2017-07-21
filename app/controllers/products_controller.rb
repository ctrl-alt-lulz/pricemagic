class ProductsController < ShopifyApp::AuthenticatedController
  before_filter :convert_percent_to_float, only: :update
  before_filter :instantiate_price_test, :collection, only: :show
  before_filter :define_product, only: [:show, :update]

  def show
    @price_test_data = PriceTest.where(product_id: params[:id]).last
    @google_analytics_data =  current_shop.metrics.last.google_product_match(@product.title)
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
     @product = ShopifyAPI::Product.find(params[:id])
  end
   
  def convert_percent_to_float
    params[:percent_increase] ||= 0
    @percent_increase = 1+(params[:percent_increase].to_f)/100
  end

  def instantiate_price_test
    @price_test = PriceTest.new
  end

  def collection
    ## TODO there's got to be a better way to do this than using begin/rescue??
    ## TODO have it handle the case of multiple collections
    ## this section finds a collection if it exists
    begin
    ## TODO refactor
      @collection = ShopifyAPI::Collect.where(product_id: params[:id]).map(&:collection_id).uniq
      @position = ShopifyAPI::Collect.where(product_id: params[:id]).map(&:position)
      @collection.each { |c| @collection_titles << ShopifyAPI::SmartCollection.find(c).title}
    rescue
      @collection = "None"
    end
  end

end
