FactoryBot.define do
  factory :item do
    association :merchant
    name { Faker::Commerce.product_name }
    description { Faker::Commerce.material }
    unit_price { Faker::Commerce.price(range: 0..100.0, as_string: true) }
  end
end