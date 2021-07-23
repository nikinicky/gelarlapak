module Orders
  module Queries
    class All
      def self.user_order(user)
        orders = user.orders.includes(snapshots: [:variant, product: [:shop]])
        orders = orders.order("orders.created_at DESC")

        return :ok, orders
      end
    end
  end
end
