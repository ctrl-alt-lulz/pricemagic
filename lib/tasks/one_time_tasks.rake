namespace :one_time_tasks do
  desc "Applies the most recent price test to the product"
  task set_all_tests_to_inactive: :environment do
    PriceTest.active.update_all(active: false)
  end
end