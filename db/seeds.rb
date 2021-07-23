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

# Seed users
User.create(
  name: Faker::Name.name,
  email: 'user@example.com',
  password: 'password',
  status: 'active'
)

User.create(
  name: Faker::Name.name,
  email: 'user2@example.com',
  password: 'password',
  status: 'active'
)

# Seed carts
users = User.where(email: ['user@example.com', 'user2@example.com'])
products = Product.all

15.times do
  product = products.sample
  shop = product.shop
  variant = product.variants.sample

  Cart.create(
    product_id: product.id,
    variant_id: variant.id,
    quantity: rand(1...5),
    description: Faker::Lorem.sentence,
    status: ['active', 'processed'].sample,
    user_id: users.sample.id,
    shop_id: shop.id
  )
end
