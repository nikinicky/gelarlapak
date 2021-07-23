class OrderSnapshot < ApplicationRecord
  belongs_to :product
  belongs_to :order
  belongs_to :variant, class_name: 'ProductVariant', foreign_key: 'variant_id'

  monetize :price_cents, allow_nil: false
end
