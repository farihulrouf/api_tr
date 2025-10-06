class ApplicationController < ActionController::API
  before_action :authorize_request

  def encode_token(payload)
    JWT.encode(payload, 'secret_key')
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, 'secret_key', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def authorize_request
    decoded = decoded_token
    if decoded
      user_id = decoded[0]['user_id']
      @current_user = User.find_by(id: user_id)
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end
end
