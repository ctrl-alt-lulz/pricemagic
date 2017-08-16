namespace :one_time_tasks do
  desc "Applies the most recent price test to the product"
  task set_all_tests_to_inactive: :environment do
    PriceTest.active.update_all(active: false)
  end
  
  desc "Apply old price test number, back fill"
  task set_all_past_price_point_number: :environment do
    PriceTest.all.update_all(price_points: 2)
  end
  
  desc "Seed price test current test start date, back fill"
  task set_all_current_price_test_start_dates: :environment do
    PriceTest.all.each do |pt|
      pt.update_attributes(current_price_started_at: pt.created_at)
    end
  end
  
  desc 'Convert metrics to individual variants'
  task convert_to_variants: :environment do
    Metric.all.each do |metric|
      shop = metric.shop
      metric.data.each do |datum|
        new_metric = shop.metrics.new(
          product_and_variant_name: datum['title'],
          page_title: datum['title'],
          page_revenue: datum['revenue'],
          page_views: datum['views'],
          page_avg_price: datum['avg_price'],
          acquired_at: metric.created_at
        )
        new_metric.save
        puts new_metric.errors.inspect unless new_metric.persisted?
      end
    end
  end
end