json.products @products do |product|
  json.partial! partial: 'api/v1/products/product_info', locals: {product: product}
  json.partial! partial: 'api/v1/products/shop_info', locals: {shop: product.shop}
end
