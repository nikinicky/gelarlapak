module Products
  module Queries
    class All
      def self.run(params)
        products = Product.includes(:variants, :shop)
        products = by_shop_type(products, params)
        products = by_product_name(products, params)

        return :ok, products
      end

      private

      def self.by_shop_type(products, params)
        if params[:shop_type].present?
          products = products.where(shops: {shop_type: params[:shop_type]})
        end

        return products
      end

      def self.by_product_name(products, params)
        if params[:product_name].present?
          products = products.where("LOWER(name) ILIKE '%#{params[:product_name]}%'")
        end

        return products
      end
    end
  end
end
