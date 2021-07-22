module Carts
  module Services
    class Create
      def self.run(params)
        params[:status] = 'active' if params[:status].nil?

        cart = Cart.new(params)

        return :unavailable, cart unless is_product_available?(params)

        if cart.save
          return :ok, cart
        else
          return :unprocessable_entity, cart
        end
      end

      private

      def self.is_product_available?(params)
        product_variant = ProductVariant.find_by(id: params[:variant_id])

        return false if product_variant.nil?
        return product_variant.stock.to_i >= params[:quantity].to_i
      end
    end
  end
end
