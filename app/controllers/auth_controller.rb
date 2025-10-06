class AuthController < ApplicationController
  skip_before_action :authorize_request, only: [:login, :register]

  def register
    user = User.new(user_params)
    user.role = "user"
    if user.save
      token = encode_token({ user_id: user.id })
      render json: { user: user, token: token }
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      token = encode_token({ user_id: user.id })
      render json: { user: user, token: token }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
