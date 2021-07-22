module Carts
  module Queries
    class All
      def self.current_user_cart(params)
        carts = Cart.includes(:variant, product: [:shop])
        carts = by_user(carts, params)
        carts = order_by_params(carts, params)

        return :ok, carts
      end

      def self.formatted_cart(params)
        result = {}
        _, carts = current_user_cart(params)

        carts.each do |cart|
          shop = cart.product.shop
          slug = shop.name.parameterize

          if result.key?(slug)
            result[slug][:products] << {
              cart_id: cart.id,
              product_id: cart.product.id,
              variant_id: cart.variant_id,
              name: cart.product.name,
              variant: cart.variant.name,
              price: cart.variant.price.to_f,
              formatted_price: "$#{cart.variant.price}",
              quantity: cart.quantity,
              stock: cart.variant.stock,
              note: cart.description
            }
          else
            result[slug] = {
              shop_info: {
                id: shop.id,
                name: shop.name,
                address: shop.address,
                shop_type: shop.shop_type
              },
              products: [
                {
                  cart_id: cart.id,
                  product_id: cart.product.id,
                  variant_id: cart.variant_id,
                  name: cart.product.name,
                  variant: cart.variant.name,
                  price: cart.variant.price.to_f,
                  formatted_price: "$#{cart.variant.price}",
                  quantity: cart.quantity,
                  stock: cart.variant.stock,
                  note: cart.description
                }
              ]
            }
          end
        end

        return :ok, result
      end

      private
      
      def self.by_user(carts, params)
        if params[:user_id].present?
          carts = carts.where(user_id: params[:user_id])
        end

        return carts
      end

      def self.order_by_params(carts, params)
        carts = carts.order("shops.name ASC, products.name ASC, product_variants.name ASC")
      end
    end
  end
end
