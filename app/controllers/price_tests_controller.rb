class PriceTestsController < ShopifyApp::AuthenticatedController

  def create
    @price_test = PriceTest.new(price_test_params)
    @price_test.save
    redirect_to product_path(@price_test.product_id)
  end

  def show
  end

  def index
  end

  private

  def price_test_params
    params.require(:price_test).permit(:percent_increase, :percent_decrease, :product_id)
  end
end