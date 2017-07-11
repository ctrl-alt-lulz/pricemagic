class ProductsController < ShopifyApp::AuthenticatedController
  before_filter :convert_percent_to_float, only: :update
  before_filter :instantiate_price_test, :collection, only: :show

  def show
    @product = ShopifyAPI::Product.find(params[:id])
    @price_test_data = PriceTest.where(product_id: params[:id]).last
  end

  def update
    @product = ShopifyAPI::Product.find(params[:id])
    @product.variants.each{|variant| variant.price = (variant.price.to_f * @percent_increase); }
    if @product.save
      redirect_to product_path(@product), notice: 'Updated successfully!'
    else
      redirect_to product_path(@product), error: @product.errors.full_messages.join(' ')
    end
  end

  private

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
      @collection = ShopifyAPI::Collect.where(product_id: params[:id]).map(&:collection_id).uniq
      @collection = ShopifyAPI::SmartCollection.find(@collection[0]).title
    rescue
      @collection = "None"
    end
  end

end
