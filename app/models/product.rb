class Product < ApplicationRecord
  belongs_to :shop
  has_many :variants, class_name: 'ProductVariant', foreign_key: 'product_id'
end
