class WalletsController < ApplicationController
  def index
    wallets = @current_user.role == "admin" ? Wallet.all : @current_user.wallets
    render json: wallets, include: :currency
  end

  def topup
   # wallet = @current_user.wallets.find(params[:wallet_id])
    wallet = @current_user.wallets.find(params[:id])

    amount = params[:amount].to_d

    WalletTransaction.create!(wallet: wallet, tx_type: 'topup', amount: amount, description: 'Top-up balance')
    wallet.update_balance!(amount)

    render json: { balance: wallet.balance }
  end
end
