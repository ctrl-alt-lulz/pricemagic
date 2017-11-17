class Mailer < ApplicationMailer
  
  def send_email(options={})
    @name = options[:name]
    @email = options[:email]
    @message = options[:message]
    mail(:to=>"alexg89@vt.edu", :subject=>"Amazon SES Email")
  end
  
end
