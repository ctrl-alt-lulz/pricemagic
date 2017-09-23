FactoryGirl.define do
  factory :price_test do
    product
    price_data { 
      { "40060822724"=>
        {"price_points"=>[14.99], "original_price"=>10.99, "current_test_price"=>14.99, "tested_price_points"=>[], "total_variant_views"=>[] }
      } 
    }
    ending_digits { 0.99 }
    price_points { 1 }
    percent_increase { 1.33 }
    percent_decrease { 1.0 }
    active { true }
  end
end