class Mailer < ApplicationMailer
  
  def send_email(options={})
    @name = options[:name]
    @email = options[:email]
    @message = options[:message]
    mail(:to=>"alexg89@vt.edu", :subject=>"Amazon SES Email")
  end

end

# class PriceTestMailer
#   def price_increased(price_test)
#     @users = price_test.shop.users
#     @subject = "Price increased!"
#     mail(:to=>@user.map(&:email), :subject=> @subject)
#   end
# end