class ReportsController < ApplicationController
  def top_crypto_users
    currency_code = params[:currency].to_s.upcase
    start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : 1.week.ago.to_date
    end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.today

    if currency_code.blank?
      return render json: { error: "Missing parameter: currency" }, status: :bad_request
    end

    currency = Currency.find_by(code: currency_code)
    return render json: { error: "Currency not found" }, status: :not_found unless currency

    transactions = WalletTransaction
      .joins(wallet: [:currency, :user])
      .where(currencies: { code: currency_code }, tx_type: 'topup', created_at: start_date.beginning_of_day..end_date.end_of_day)

    if transactions.empty?
      return render json: {
        currency: currency_code,
        period: "#{start_date} to #{end_date}",
        top_users: [],
        message: "No transactions found in this date range."
      }
    end

    top_users = transactions
      .group('users.name')
      .sum(:amount)
      .sort_by { |_, total| -total }
      .first(10)
      .map { |name, total| { user: name, total_amount: total.to_f.round(8) } }

    render json: {
      currency: currency_code,
      period: "#{start_date} to #{end_date}",
      top_users: top_users
    }
  rescue ArgumentError
    render json: { error: "Invalid date format. Use YYYY-MM-DD" }, status: :bad_request
  end


  # GET /reports/balance_comparison?currency1=IDR&currency2=USD
  def balance_comparison
    currency1 = params[:currency1] || 'IDR'
    currency2 = params[:currency2] || 'USD'

    users_currency1 = Wallet.joins(:currency)
      .where(currencies: { code: currency1 })
      .where('wallets.balance > 0')
      .distinct
      .count(:user_id)

    users_currency2 = Wallet.joins(:currency)
      .where(currencies: { code: currency2 })
      .where('wallets.balance > 0')
      .distinct
      .count(:user_id)

    difference = users_currency1 - users_currency2

    render json: {
      currency1: currency1,
      currency2: currency2,
      users_with_balance: {
        currency1 => users_currency1,
        currency2 => users_currency2
      },
      difference: difference
    }
  end


  def top_balance_change_day
    currency_code = params[:currency] || 'IDR'

    result = WalletTransaction
               .joins(wallet: :currency)
               .where(currencies: { code: currency_code })
               .group("DATE(wallet_transactions.created_at)")
               .sum(:amount)
               .sort_by { |_, total| -total }
               .first

    if result
      render json: {
        currency: currency_code,
        top_day: result[0],
        total_change: result[1].round(6)
      }
    else
      render json: {
        currency: currency_code,
        message: "Tidak ada transaksi ditemukan untuk #{currency_code}"
      }, status: :not_found
    end
  end
end
