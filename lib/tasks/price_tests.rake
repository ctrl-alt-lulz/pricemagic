namespace :price_tests do
  desc "Applies the active price test to the product"
  task apply: :environment do
    PriceTest.active.each(&:apply_price_increase!)
  end
end
