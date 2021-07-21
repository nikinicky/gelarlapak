class Api::V1::SessionsController < ApplicationController
  def login
    @user = User.find_for_authentication(email: params[:email])
    valid_password = @user.try(:valid_password?, params[:password])

    if @user.present? && valid_password
      @token = encode_token(@user)
    else
      render json: {
        message: "The email address or password you entered is incorrect."
      }, status: :unprocessable_entity
    end
  end
end
