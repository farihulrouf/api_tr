Rails.application.routes.draw do
  # --- API Routes ---
  post '/register', to: 'auth#register'
  post '/login', to: 'auth#login'

  resources :wallets, only: [:index] do
    post :topup, on: :member
  end

  get '/reports/top_crypto_users', to: 'reports#top_crypto_users'
  get '/reports/balance_comparison', to: 'reports#balance_comparison'
  get '/reports/top_balance_change_day', to: 'reports#top_balance_change_day'

  # --- Swagger (Docs) ---
  if Rails.env.development?
    mount Rswag::Ui::Engine => '/docs'
    mount Rswag::Api::Engine => '/api-docs'
  end
end
