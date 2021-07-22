class Api::V1::CartsController < ApplicationController
  before_action :authenticate_user
  before_action :set_cart, only: [:update]

  def create
    status, cart = Carts::Services::Create.run(cart_params)

    if status == :ok
      render json: {
        success: true 
      }, status: :ok and return
    else
      render json: {
        success: false, 
        message: "Your selected item is unavailable."
      }, status: :unprocessable_entity and return
    end
  end

  def index
    status, @carts = Carts::Queries::All.formatted_cart(cart_params)
  end

  def update
    status, cart = Carts::Services::Update.run(@cart, cart_params)

    if status == :ok
      render json: {
        success: true 
      }, status: :ok and return
    else
      render json: {
        success: false, 
        message: "Your selected item is unavailable."
      }, status: :unprocessable_entity and return
    end
  end

  private

  def cart_params
    params[:user_id] = @current_user.id
    params[:status] = 'active' if params[:status].nil?
    params.permit(:product_id, :variant_id, :quantity, :description, :status, :user_id)
  end

  def set_cart
    @cart = Cart.find_by(id: params[:id])
  end
end
