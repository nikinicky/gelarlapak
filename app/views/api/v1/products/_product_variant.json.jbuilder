json.variants product.variants do |variant|
  json.id variant.id
  json.name variant.name
  json.formatted_price  "$#{variant.price}"
  json.stock variant.stock
end
