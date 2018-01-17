class BillingsController < ApplicationController
  skip_before_filter :confirm_billing
  before_filter :remove_session
  def index
  end
  
  def show
  end

  def new
  end

  private 

  def remove_session
    session.delete(:billing_fail)
  end
end