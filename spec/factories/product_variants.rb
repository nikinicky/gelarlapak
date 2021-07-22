FactoryBot.define do
  factory :product_variant do
    name {Faker::Commerce.color}
    price_cents {(Faker::Commerce.price * 100)}
    price_currency {'USD'}
    stock {rand(1...5)}
    status {'active'}
  end
end
