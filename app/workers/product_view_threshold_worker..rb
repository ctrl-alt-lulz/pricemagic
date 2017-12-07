class ProductViewThresholdWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 10

  def perform
    Shop.all.each do |shop|
      shop.with_shopify!
      shop.price_tests.active.each do |pt|
        ## have pricetest show latest views
        pt.update_revenue_and_view_metrics
        next unless pt.hit_threshold? ## check to see if hit threshold
        pt.shift_price_point!
        pt.make_inactive! if pt.done?
      end
    end
  end
end
