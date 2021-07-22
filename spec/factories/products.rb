FactoryBot.define do
  factory :product do
    name {Faker::Commerce.product_name}
    description {Faker::Lorem.paragraph}
    average_rating {rand(3.0...5.0).round(2)}
    # total_sold {rand(0...1000)}
    status {'active'}

    after(:create) do |product, evaluator|
      rand(1...5).times.each do
        create(
          :product_variant, 
          product_id: evaluator.id, 
          name: Faker::Commerce.color, 
          price_cents: (Faker::Commerce.price * 100), 
          price_currency: 'USD', 
          stock: rand(1...5),
          status: 'active'
        )
      end
    end
  end
end
