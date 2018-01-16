class FaqController < ApplicationController
  skip_before_filter :confirm_billing

  def index
  end

  def show
  end

  def new
  end

  private
end