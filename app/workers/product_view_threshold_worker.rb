class ProductViewThresholdWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1

  def perform
    Shop.all.each do |shop|
      shop.price_tests.active.each do |pt|
        next unless pt.hit_threshold? ## check to see if hit threshold
        pt.done? ? pt.make_inactive! : pt.shift_price_point!
      end
    end
  end
end
