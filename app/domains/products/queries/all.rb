module Products
  module Queries
    class All
      def self.run(params)
        products = Product.includes(:variants, :shop)
        products = by_shop_type(products, params)

        return :ok, products
      end

      private

      def self.by_shop_type(products, params)
        if params[:shop_type].present?
          products = products.where(shops: {shop_type: params[:shop_type]})
        end

        return products
      end
    end
  end
end
