module ApplicationHelper
	def base_url
		Rails.configuration.public_url
	end
end

module PriceTestHelper
  def price_tests(id)  
  	@price_tests = PriceTest.where(product_id: id).first.try(:active)
  	@price_tests ?  @price_tests.to_s.capitalize : "None"
  end
end