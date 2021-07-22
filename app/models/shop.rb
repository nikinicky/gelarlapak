class Shop < ApplicationRecord
  has_many :products

  BRONZE = 'bronze'.freeze
  SILVER = 'silver'.freeze
  GOLD = 'gold'.freeze
  DIAMOND = 'diamond'.freeze
  SHOP_TYPES = [self::BRONZE, self::SILVER, self::GOLD, self::DIAMOND].freeze
end
