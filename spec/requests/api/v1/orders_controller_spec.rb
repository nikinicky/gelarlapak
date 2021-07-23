require 'rails_helper'

RSpec.describe "Api::V1::Orders", type: :request do
  describe "POST /api/v1/orders" do
    context 'with valid params' do
      before do
        @user = create(:user)
        token = encode_token(@user)
        headers = {Authorization: "Bearer #{token}"}

        shop_a = create(:shop)
        product_a = create(:product, shop_id: shop_a.id)
        variant_a_a = create(:product_variant, product_id: product_a.id, stock: 5)
        @cart1 = create(:cart, product_id: product_a.id, variant_id: variant_a_a.id, user_id: @user.id, shop_id: shop_a.id)
        @cart2 = create(:cart, product_id: product_a.id, variant_id: product_a.variants.first.id, user_id: @user.id, shop_id: shop_a.id)

        shop_b = create(:shop)
        product_b = create(:product, shop_id: shop_b.id)
        variant_b_a = create(:product_variant, product_id: product_a.id, stock: 5)
        @cart3 = create(:cart, product_id: product_b.id, variant_id: variant_b_a.id, user_id: @user.id, shop_id: shop_b.id)

        params = {cart_ids: [@cart1.id, @cart2.id, @cart3.id]}

        post api_v1_orders_path, params: params, headers: headers
      end

      it 'status should be 200' do
        expect(response.status).to eq(200)
      end

      it 'should create orders' do
        expect(@user.orders.size).to eq(2)
      end

      it 'cart should not active anymore' do
        @cart1.reload
        @cart2.reload
        @cart3.reload
        expect(@cart1.status).not_to eq('active')
        expect(@cart2.status).not_to eq('active')
        expect(@cart3.status).not_to eq('active')
      end
    end
  end
end
