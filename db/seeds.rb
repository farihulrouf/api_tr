require 'faker'

puts "🧹 Menghapus semua data lama..."
WalletTransaction.destroy_all
Wallet.destroy_all
Currency.destroy_all
User.destroy_all

# === USERS ===
puts "👤 Membuat admin dan 100 user..."
admin = User.create!(
  name: "Admin",
  email: "admin@example.com",
  password: "admin123",
  role: "admin"
)

100.times do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: "password",
    role: "user"
  )
end

puts "✅ #{User.count} user dibuat."

# === CURRENCIES ===
puts "💱 Membuat fiat + crypto + stablecoin..."
currencies_data = [
  { code: "IDR",  name: "Rupiah" },
  { code: "USD",  name: "US Dollar" },
  { code: "BTC",  name: "Bitcoin" },
  { code: "ETH",  name: "Ethereum" },
  { code: "BNB",  name: "Binance Coin" },
  { code: "XRP",  name: "Ripple" },
  { code: "USDT", name: "Tether USD" },
  { code: "USDC", name: "USD Coin" },
  { code: "DAI",  name: "Dai" },
  { code: "TUSD", name: "TrueUSD" },
  { code: "BUSD", name: "Binance USD" },
  { code: "PYUSD", name: "PayPal USD" }
]

currencies = currencies_data.map { |data| Currency.create!(data) }

puts "✅ #{Currency.count} currencies dibuat."

# === WALLETS ===
puts "💼 Membuat wallets untuk semua user..."
User.all.each do |user|
  currencies.each do |currency|
    Wallet.create!(user: user, currency: currency, balance: 0)
  end
end
puts "✅ #{Wallet.count} wallets dibuat."

# === TRANSAKSI RANDOM ===
puts "💸 Membuat transaksi random realistis..."

def random_tx(wallet, tx_type:, amount:, description:, created_at:)
  WalletTransaction.create!(
    wallet: wallet,
    tx_type: tx_type,
    amount: amount,
    description: description,
    created_at: created_at,
    updated_at: created_at
  )
  wallet.update!(balance: wallet.balance + amount)
end

Wallet.all.each do |wallet|
  rand(8..30).times do
    tx_type = ["topup", "withdraw"].sample
    created_at = rand(0..30).days.ago

    amount =
      case wallet.currency.code
      when "IDR" then rand(100_000..2_000_000) * (tx_type == "withdraw" ? -1 : 1)
      when "USD" then rand(10..500) * (tx_type == "withdraw" ? -1 : 1)
      when "BTC" then rand(0.0003..0.05).round(5) * (tx_type == "withdraw" ? -1 : 1)
      when "ETH" then rand(0.001..0.5).round(5) * (tx_type == "withdraw" ? -1 : 1)
      when "BNB" then rand(0.01..1.0).round(4) * (tx_type == "withdraw" ? -1 : 1)
      when "XRP" then rand(1..200).round(2) * (tx_type == "withdraw" ? -1 : 1)
      else
        rand(1..500).round(2) * (tx_type == "withdraw" ? -1 : 1)
      end

    random_tx(
      wallet,
      tx_type: tx_type,
      amount: amount,
      description: "#{tx_type.capitalize} #{wallet.currency.code}",
      created_at: created_at
    )
  end
end

puts "✅ #{WalletTransaction.count} transaksi dibuat."
puts "🎉 Seeder selesai!"
puts "- Users: #{User.count}"
puts "- Wallets: #{Wallet.count}"
puts "- Transactions: #{WalletTransaction.count}"
puts "- Currencies: #{Currency.count}"
