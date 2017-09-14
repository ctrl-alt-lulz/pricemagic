FactoryGirl.define do
  factory :metric do
     shop
     product ## TODO ensure shop is the same as above
     variant
     page_title { Faker::Book.title }
     page_revenue { 0.0 }
     page_views { 1 }
     page_avg_price { 0.0 }
     acquired_at { 4.days.ago }
  end
end