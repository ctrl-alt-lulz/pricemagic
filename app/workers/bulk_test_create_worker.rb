class BulkTestCreateWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  def perform(params)
    shop = Shop.find(PriceTest.where(product_id: params[0]).last.shop.id)
    shop.with_shopify!
    puts '*'*50
    puts params.inspect.class
    puts params[0]
    puts PriceTest.where(product_id: params[0]).count
    puts PriceTest.where(product_id: params[0])
    puts PriceTest.where(product_id: params[0]).last.product.title
    PriceTest.where(product_id: params[0]).last.product.title
    PriceTest.where(product_id: params[0]).last.apply_current_test_price!
    puts '*'*50    
  end
  # def perform(params)
  #   puts '*'*50
  #   puts params.inspect
  #   puts '*'*50
  #   hash = params.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  #   product_ids = hash.delete(:product_ids).split(' ')
  #   product_ids.each do |id|
  #     @price_test = PriceTest.new(hash.merge(product_id: id ))
  #     @price_test.save
  #     puts '*'*50
  #     puts id
  #     puts hash.inspect
  #     puts params.merge(product_id: id)
  #     puts @price_test.inspect
  #     puts @price_test.errors.inspect
  #     puts '*'*50
  #   end 
  # end
end