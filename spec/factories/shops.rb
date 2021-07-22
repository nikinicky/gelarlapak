FactoryBot.define do
  factory :shop do
    name {Faker::Company.name}
    address {Faker::Address.city}
    description {Faker::Lorem.paragraph}
    shop_type {Shop::SHOP_TYPES.sample}
    status {'active'}
  end
end
