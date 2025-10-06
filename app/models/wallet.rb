class Wallet < ApplicationRecord
  belongs_to :user
  belongs_to :currency
  has_many :wallet_transactions

  def update_balance!(amount)
    self.balance += amount
    save!
  end
end
