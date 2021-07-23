class Order < ApplicationRecord
  belongs_to :user
  has_many :snapshots, class_name: 'OrderSnapshot', foreign_key: 'order_id'
end
