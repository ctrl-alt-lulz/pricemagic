namespace :one_time_tasks do
  desc "Applies the most recent price test to the product"
  task set_all_tests_to_inactive: :environment do
    PriceTest.active.update_all(active: false)
  end
  
  desc "Apply old price test number, back fill"
  task set_all_past_price_point_number: :environment do
    PriceTest.all.update_all(price_points: 2)
  end
end