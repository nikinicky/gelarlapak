json.id product.id
json.name product.name
json.description product.description
json.average_rating product.average_rating
json.status product.status
json.formatted_price "$#{(product.variants.minimum(:price_cents)/100)}"
