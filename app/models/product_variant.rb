class ProductVariant < ApplicationRecord
  monetize :price_cents, allow_nil: false

  belongs_to :product
end
