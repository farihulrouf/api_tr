class User < ApplicationRecord
  has_secure_password
  has_many :wallets
  validates :email, presence: true, uniqueness: true
end
