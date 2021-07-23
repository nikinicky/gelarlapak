require 'rails_helper'

RSpec.describe "Orders::Queries::GetTotalPrice", type: :request do
  describe '.run' do
    context 'total price from an order' do
      before do
        user = create(:user)
        shop_a = create(:shop)
        @product_a = create(:product, shop_id: shop_a.id)
        @variant_a_a = create(:product_variant, product_id: @product_a.id, stock: 5)
        @cart1 = create(:cart, product_id: @product_a.id, variant_id: @variant_a_a.id, user_id: user.id, shop_id: shop_a.id)
        @cart2 = create(:cart, product_id: @product_a.id, variant_id: @product_a.variants.first.id, user_id: user.id, shop_id: shop_a.id)

        shop_b = create(:shop)
        product_b = create(:product, shop_id: shop_b.id)
        variant_b_a = create(:product_variant, product_id: product_b.id, stock: 5)
        @cart3 = create(:cart, product_id: product_b.id, variant_id: variant_b_a.id, user_id: user.id, shop_id: shop_b.id)

        params = {cart_ids: [@cart1.id, @cart2.id, @cart3.id]}

        _, @orders = Orders::Services::Create.run(params, user)

        @status, @total_price = Orders::Queries::GetTotalPrice.run(@orders.first)
      end

      it 'status should be :ok' do
        expect(@status).to eq(:ok)
      end

      it 'should return total price' do
        price1 = @variant_a_a.price.to_f
        price2 = @product_a.variants.first.price.to_f
        expectation = price1 + price2

        expect(@total_price).to eq(expectation.round(2))
      end
    end
  end
end
