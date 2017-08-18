class BulkTestCreateWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 5

  def perform(params)
    puts '*'*50
    puts params.inspect
    puts '*'*50
    hash = params.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    product_ids = hash.delete(:product_ids).split(' ')
    product_ids.each do |id|
      @price_test = PriceTest.new(hash.merge(product_id: id ))
      @price_test.save
      puts '*'*50
      puts id
      puts hash.inspect
      puts params.merge(product_id: id)
      puts @price_test.inspect
      puts @price_test.errors.inspect
      puts '*'*50
    end 
  end
end