module Orders
  module Services
    class Create
      def self.run(params, user)
        carts = Cart.where(id: params[:cart_ids])
        shop_ids = carts.pluck(:shop_id).uniq

        orders = []

        shop_ids.each do |shop_id|
          ActiveRecord::Base.transaction do
            order = Order.new(code: OrderHelper.generate_code, user_id: user.id)

            if order.save
              snapshot_data = carts.where(shop_id: shop_id)
              snapshot_status = []

              snapshot_data.each do |data|
                snapshot = OrderSnapshot.create(
                  order_id: order.id, 
                  product_id: data.product_id, 
                  variant_id: data.variant_id,
                  quantity: data.quantity,
                  price_cents: data.variant.price_cents,
                  price_currency: data.variant.price_currency
                )

                snapshot_status << snapshot.persisted?

                if snapshot.persisted?
                  Carts::Services::Update.run(data, {status: 'processed'})
                end
              end

              raise ActiveRecord::Rollback if snapshot_status.include?(false)

              orders << order
            end
          end
        end

        return :ok, orders
      end
    end
  end
end
