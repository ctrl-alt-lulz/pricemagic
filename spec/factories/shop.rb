FactoryGirl.define do
  factory :shop do
    shopify_domain { Faker::Internet.url }
    shopify_token { SecureRandom.hex }
  end
end