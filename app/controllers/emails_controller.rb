class EmailsController < ApplicationController
  
  def index
  end
  
  def send_email
    # RecurringChargeMailer.account_canceled(obj1, obj2).deliver_now
    # ProductMailer.new_product(product)
    # PriceTestMailer.price_increased(price_test)
    
    Mailer.send_email(name: params[:name], email: params[:email], message: params[:message]).deliver_now
    redirect_to root_url, notice: "Email sent!"
  end
end
