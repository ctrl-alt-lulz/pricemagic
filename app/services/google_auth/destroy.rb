class GoogleAuth::Destroy
  include Service
  
  attr_reader :shop
  
  def initialize(current_shop)
    @shop = current_shop
  end
  
  def call
    stop_price_tests
    remove_google_from_all_users
    shop
  end
  
  private

  def remove_google_from_all_users
    shop.users.each(&:remove_google!)
  end

  ## shut down price tests if only google account associated
  def stop_price_tests
    shop.stop_price_tests! if shop.latest_access_token.nil? 
  end
end