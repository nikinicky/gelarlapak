# Seed shops
15.times do
  Shop.create!(
    name: Faker::Company.name,
    address: Faker::Address.city,
    description: Faker::Lorem.paragraph,
    shop_type: Shop::SHOP_TYPES.sample,
    status: 'active'
  )
end
  

# Seed products
shops = Shop.all

50.times do
  product = Product.create!(
    name: Faker::Commerce.product_name,
    shop_id: shops.sample.id,
    description: Faker::Lorem.paragraph,
    average_rating: rand(3.0...5.0).round(1),
    status: 'active'
  )

  rand(1...5).times do
    ProductVariant.create!(
      product_id: product.id,
      name: Faker::Commerce.color,
      price_cents: (Faker::Commerce.price * 100),
      price_currency: 'USD',
      stock: rand(0...5),
      status: 'active'
    )
  end
end
