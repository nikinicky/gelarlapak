class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates_presence_of :name
  validates :email, uniqueness: true

  ACTIVE = 'active'.freeze
  INACTIVE = 'inactive'.freeze
end
