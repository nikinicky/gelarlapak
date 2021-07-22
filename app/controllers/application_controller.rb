class ApplicationController < ActionController::API
  before_action { request.format = :json }

  def encode_token(user, expiration=nil)
    expiration ||= Rails.application.credentials[Rails.env.to_sym][:jwt_expiration_hours]

    payload = {
      user_id: user.id,
      exp: expiration.to_i.hours.from_now.to_i
    }
   
    JWT.encode(
      payload, Rails.application.credentials[Rails.env.to_sym][:jwt_secret_key], 
      Rails.application.credentials[Rails.env.to_sym][:jwt_algorithm]
    )
  end

  def authenticate_user
    authenticate_token || render_unauthorized
  end

  def render_unauthorized
    render json: {message: 'Please login to access this page.'}, status: :unauthorized
  end

  def authenticate_token
    if decoded_token
      user = User.find_by(id: decoded_token.first['user_id'])
      @current_user = user
    else
      render_unauthorized
    end
  end

  private

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    return nil unless auth_header

    token = auth_header.split(' ')[1]

    begin
      JWT.decode(token, Rails.application.credentials[Rails.env.to_sym][:jwt_secret_key], true, {algorithm: Rails.application.credentials[Rails.env.to_sym][:jwt_algorithm]})
    rescue JWT::ExpiredSignature
      puts 'token expired'
      nil
    rescue JWT::DecodeError
      nil
    end
  end
end
