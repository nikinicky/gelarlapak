module Orders
  module Queries
    class GetTotalPrice
      def self.run(order)
        total_price = 0.0

        order.snapshots.each do |snapshot|
          total_price += sub_total_per_variant(order, snapshot.variant)
        end

        return :ok, total_price.round(2)
      end

      def self.sub_total_per_variant(order, variant)
        snapshot = OrderSnapshot.find_by(order_id: order.id, variant_id: variant.id)

        sub_total = snapshot.quantity * snapshot.price.to_f

        return sub_total.round(2)
      end
    end
  end
end
