class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_user

  def create
    status, orders = Orders::Services::Create.run(order_params, @current_user)

    if status == :ok
      render json: {
        success: true 
      }, status: :ok and return
    else
      render json: {
        success: false, 
        message: "Something wrong."
      }, status: :unprocessable_entity and return
    end
  end

  def index
    status, @orders = Orders::Queries::All.user_order(@current_user)
  end

  private

  def order_params
    params.permit(cart_ids: [])
  end
end
