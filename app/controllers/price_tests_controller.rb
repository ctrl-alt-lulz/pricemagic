class PriceTestsController < ShopifyApp::AuthenticatedController

  def create
    @price_test = current_shop.price_tests.new(price_test_params)
    if @price_test.save
      respond_to do |format|
        format.html { redirect_to product_path(@price_test.product_id), notice: 'You did it! Hooray!' }
        format.json { render json: { success: true, id: @price_test.id }, status: 201 }
      end
    else
      respond_to do |format|
        format.html { redirect_to product_path(params[:price_test][:product_id]), notice: @price_test.errors.full_messages.uniq.to_sentence }
        format.json { render json: { success: false, message: @price_test.errors.full_messages.to_sentence }, status: 400 }
      end
    end
  end
  
  ## Note to self hidden products can mess with this
  def destroy
    price_test = current_shop.price_tests.find(params[:id])
    product_id = price_test.product_id
    if price_test.destroy
      respond_to do |format|
        format.html { redirect_to product_path(product_id), notice: 'Price test removed!' }
        format.json { render json: { success: true }, status: 201 }
      end
    else
      respond_to do |format|
        format.html { redirect_to product_path(product_id), notice: 'Price test could not be removed.' }
        format.json { render json: { success: false, message: @price_test.errors.full_messages.to_sentence }, status: 400 }
      end
    end
  end
  
  def bulk_create
    flash[:notice] = "Creating Price Tests in the Background"
    BulkCreatePriceTestsWorker.perform_async(params)
    respond_to do |format|
      format.json { render json: { success: true }, status: 201 }
    end
  end
  
  def bulk_destroy
    flash[:notice] = "Deleting Price Tests in the Background"
    unless params[:product_ids].nil?
      BulkDestroyPriceTestsWorker.perform_async(params[:product_ids])
    end
    respond_to do |format|
      format.json { render json: { success: true }, status: 201 }
    end
  end
  
  def update
    price_test = current_shop.price_tests.find(params[:id])
    if price_test.update_attributes(price_test_params)
      redirect_to product_path(price_test.product_id), notice: 'Price test updated!'
    else
      redirect_to product_path(price_test.product_id), notice: 'Price test could not be updated.'
    end
  end

  private

  def price_test_params
    params.require(:price_test).permit(:percent_increase, :percent_decrease,
                   :product_id, :ending_digits, :price_points, :active, 
                   :product_ids, :view_threshold)
  end
end