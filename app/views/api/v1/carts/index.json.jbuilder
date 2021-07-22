json.carts @carts do |key, cart|
  json.shop_info do
    json.id cart[:shop_info][:id]
    json.name cart[:shop_info][:name]
    json.address cart[:shop_info][:address]
    json.shop_type cart[:shop_info][:shop_type]
  end

  json.products cart[:products] do |product|
    json.cart_id product[:cart_id]
    json.product_id product[:product_id]
    json.variant_id product[:variant_id]
    json.name product[:name]
    json.variant product[:variant]
    json.price product[:price]
    json.formatted_price product[:formatted_price]
    json.quantity product[:quantity]
    json.stock product[:stock]
    json.note product[:note]
  end
end
