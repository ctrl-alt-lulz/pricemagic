class WorkersController < ShopifyApp::AuthenticatedController

  def seed_products_and_variants
    shop_id = params[:id]
    SingleShopSeedProductsAndVariantsWorker.perform_async(shop_id)
    respond_to do |format|
      format.json { render json: { success: true }, status: 201 }
    end
  end
  
  def query_google
    shop_id = params[:id]
    SingleShopQueryGoogleApiWorker.perform_async(shop_id)
    respond_to do |format|
      format.json { render json: { success: true }, status: 201 }
    end
  end
  
  def update_price_tests_statuses
    shop_id = params[:id]
    SingleShopQueryGoogleApiWorker.perform_async(shop_id)
    respond_to do |format|
      format.json { render json: { success: true }, status: 201 }
    end
  end
  
  private
  
end
