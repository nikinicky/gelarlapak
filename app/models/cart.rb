class Cart < ApplicationRecord
  belongs_to :product
  belongs_to :user
  belongs_to :variant, class_name: 'ProductVariant', foreign_key: 'variant_id'
end
