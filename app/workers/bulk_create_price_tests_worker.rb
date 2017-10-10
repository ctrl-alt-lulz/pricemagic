class BulkCreatePriceTestsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1

  def perform(params)
    price_test_params = params['price_test']
    product_ids = price_test_params.delete('product_ids')
    shop = Shop.find(Product.find(product_ids.first).shop.id)
    shop.with_shopify!
    price_test_params = price_test_params.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    product_ids.each do |id|
      @price_test = PriceTest.new(price_test_params.merge(product_id: id))
      @price_test.save
    end 
  end
end