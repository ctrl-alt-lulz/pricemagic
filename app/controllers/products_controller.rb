class ProductsController < ShopifyApp::AuthenticatedController
  before_filter :convert_percent_to_float, only: :update
  before_filter :instantiate_price_test, :define_collection, only: :show
  before_filter :define_product, only: [:show, :update]

  def show
    @price_test_data = PriceTest.where(shopify_product_id: @product.shopify_product_id).last
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

  def google_variant_match(name)
    self.keep_if{ |m| m['title'].ends_with?(name) }  
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
      @collections =  ShopifyAPI::Collect.where(product_id: params[:id]).map do |c| 
                        { 
                          position: c.position, 
                          title: ShopifyAPI::SmartCollection.find(c.collection_id).title 
                        }
                      end
  end

end
