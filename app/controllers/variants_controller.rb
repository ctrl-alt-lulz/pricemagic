class VariantsController < ShopifyApp::AuthenticatedController
  before_filter :define_variant, only: [:update]

  def update
    session[:return_to] ||= request.referer
    @variant.unit_cost = params[:unit_cost]
    if @variant.update_attributes(variant_params)
      respond_to do |format|
        format.html { redirect_to session.delete(:return_to), notice: 'Updated successfully!' }
        format.json { render json: { success: true, unitPriceValueHash:  @variant.product.variant_unit_cost_hash }, status: 201 }
      end
    else
      respond_to do |format|
        format.html { redirect_to session.delete(:return_to), error: @variant.errors.full_messages.join(' ') }
        format.json { render json: { success: false, message: @variant.errors.full_messages.to_sentence }, status: 400 }
      end
    end
  end
  
  private
  
  def define_variant
     @variant = Variant.find(params[:id])
  end
  
  def variant_params
    params.require(:variant).permit(:unit_cost)
  end
end
