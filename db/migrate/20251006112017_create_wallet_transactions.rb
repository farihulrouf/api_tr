class CreateWalletTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :wallet_transactions do |t|
      t.references :wallet, null: false, foreign_key: true
      t.string :tx_type
      t.decimal :amount
      t.text :description

      t.timestamps
    end
  end
end
