class PriceTestsController < ShopifyApp::AuthenticatedController

  def create
    @price_test = PriceTest.new(price_test_params)
    if @price_test.save
      respond_to do |format|
        format.html { redirect_to product_path(@price_test.product_id), notice: 'You did it! Hooray!' }
        format.js { render action: "create" }
        format.json { render json: { success: true, id: @price_test.id }, status: 201 }
      end
    else
      respond_to do |format|
        format.html { redirect_to product_path(params[:price_test][:product_id]), notice: @price_test.errors.full_messages.to_sentence }
        format.js { render action: "create"}
        format.json { render json: { success: false, message: @price_test.errors.full_messages.to_sentence }, status: 400   }
      end
    end
  end

  def show
  end

  def index
  end
  
  def edit
  end
  
  def update
    ## TODO write the update case
  end
  
  def destroy
    price_test = PriceTest.find(params[:id])
    product_id = price_test.product_id
    if price_test.destroy
      redirect_to product_path(product_id), notice: 'Price test removed!'
    else
      redirect_to product_path(product_id), notice: 'Price test could not be removed.'
    end
  end

  private

  def price_test_params
    params.require(:price_test).permit(:percent_increase, :percent_decrease,
                   :product_id, :ending_digits, :price_points)
  end
end