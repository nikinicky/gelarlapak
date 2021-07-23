class Api::V1::ProductsController < ApplicationController
  def index
    _, @products = Products::Queries::All.run(product_params)
  end

  def show
    @product = Product.find_by(id: params[:id])

    if @product.nil?
      render json: {
        message: "Something wrong."
      }, status: :unprocessable_entity and return
    end
  end

  private

  def product_params
    params.permit(:shop_type, :product_name)
  end
end
