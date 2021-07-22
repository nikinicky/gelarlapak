module Carts
  module Services
    class Update
      def self.run(cart, params)
        return :unavailable, cart unless is_product_available?(cart, params)

        cart = update_status(cart, params)
        cart = update_quantity(cart, params)

        if cart.save
          return :ok, cart
        else
          return :unprocessable_entity, cart
        end
      end

      private

      def self.update_status(cart, params)
        if params[:status].present? && cart.status != params[:status]
          cart.status = params[:status]
        end

        return cart
      end

      def self.update_quantity(cart, params)
        if params[:quantity].present? && cart.quantity != params[:quantity]
          cart.quantity = params[:quantity]
        end

        return cart
      end

      def self.is_product_available?(cart, params)
        return true if params[:quantity].nil?

        product_variant = ProductVariant.find_by(id: cart.variant_id)

        return false if product_variant.nil?
        return product_variant.stock.to_i >= params[:quantity].to_i
      end
    end
  end
end
