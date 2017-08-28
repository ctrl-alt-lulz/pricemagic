# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#

shop = Shop.first
shop.with_shopify!
products = Product.first(10)
products.each do |product|
  @price_test = PriceTest.new(product_id: product.id, percent_increase: 30,
                              percent_decrease: 30,  price_points: 3, 
                              active: true)
  @price_test.save
  @price_test = PriceTest.find_by(product_id: product.id)
  3.times{@price_test.shift_price_point!}
  @price_test.price_data.each{|k,v| v["total_variant_views"] = [500, 500, 500]}
  @price_test.save
end 
