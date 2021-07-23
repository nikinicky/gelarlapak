class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :orders

  validates_presence_of :name
  validates :email, uniqueness: true

  ACTIVE = 'active'.freeze
  INACTIVE = 'inactive'.freeze
end
