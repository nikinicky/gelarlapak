json.orders @orders do |order|
  json.id order.id
  json.code order.code
  json.status order.status
  json.purchase_date (order.created_at + 7.hours).strftime("%-d %B %Y %H:%M")

  _, total_price = Orders::Queries::GetTotalPrice.run(order)
  json.total_price total_price
  json.formatted_total_price "$#{total_price}"

  shop = order.snapshots.first.product.shop
  json.shop_info do
    json.id shop.id
    json.name shop.name
    json.address shop.address
    json.shop_type shop.shop_type
  end

  json.products order.snapshots do |snapshot|
    sub_total = Orders::Queries::GetTotalPrice.sub_total_per_variant(order, snapshot.variant)

    json.id snapshot.product.id
    json.name snapshot.product.name
    json.variant snapshot.variant.name
    json.quantity snapshot.quantity
    json.price snapshot.price.to_f
    json.sub_total sub_total
    json.formatted_sub_total "$#{sub_total}"
  end
end
