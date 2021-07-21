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
end
