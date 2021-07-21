class Api::V1::UsersController < ApplicationController
  def register
    status, @user = Users::Services::Create.run(user_params)

    if status == :registered
      render json: {
        success: false, 
        message: "Email is already registered, please enter another email address."
      }, status: :unprocessable_entity
    elsif status == :unprocessable_entity
      render json: {
        success: false, 
        message: @user.errors.full_messages.first
      }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password)
  end
end
