# Seed shops
[
  {
    name: 'Tokopaedi',
    address: 'Jakarta Selatan',
    description: '',
    shop_type: 'bronze'
  }
].each do |shop|
  Shop.find_or_create_by(shop)
end

# Seed products
shops = Shop.all

[
  {
    name: "iPad Mini 5 Wi-Fi Cell 6GB 64GB",
    shop_id: shops.sample.id,
    description: 'BNIB',
    average_rating: rand(3.0...5.0).round(2),
    variant: [
      {name: 'Grey', price_cents: 20000, price_currency: 'USD', stock: rand(0...10)},
      {name: 'Gold', price_cents: 21000, price_currency: 'USD', stock: rand(0...10)},
      {name: 'Silver', price_cents: 22000, price_currency: 'USD', stock: rand(0...10)}
    ]
  }
].each do |product_params|
  product = Product.find_or_create_by(product_params.except(:variant))

  product_params[:variant].each do |variant_params|
    variant_params[:product_id] = product.id
    ProductVariant.find_or_create_by(variant_params)
  end
end
