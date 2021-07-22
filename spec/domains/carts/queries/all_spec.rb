require 'rails_helper'

RSpec.describe "Carts::Queries::All", type: :request do
  describe '.current_user_cart' do
    context 'user has active cart' do
      before do
        user = create(:user)
        @shop = create(:shop)
        @product = create(:product, shop_id: @shop.id)
        @variant = create(:product_variant, product_id: @product.id, stock: 5)
        cart = create(:cart, product_id: @product.id, variant_id: @variant.id, user_id: user.id)

        params = {
          user_id: user.id
        }

        @status, @carts = Carts::Queries::All.current_user_cart(params)
      end

      it 'status should be :ok' do
        expect(@status).to eq(:ok)
      end

      it 'should return charts' do
        expect(@carts.size).to eq(1)
      end
    end

    context 'user has some product in his cart' do
      before do
        user = create(:user)

        @shop_b = create(:shop, name: 'shop 2')
        @product_b1 = create(:product, shop_id: @shop_b.id, name: 'product b1')
        @variant_b1_b = create(:product_variant, product_id: @product_b1.id, stock: 5, name: 'variant b')
        @cart_b1_b = create(:cart, product_id: @product_b1.id, variant_id: @variant_b1_b.id, user_id: user.id)

        @shop_a = create(:shop, name: 'shop 1')
        @product_a2 = create(:product, shop_id: @shop_a.id, name: 'product a2')
        @variant_a2_c = create(:product_variant, product_id: @product_a2.id, stock: 5, name: 'variant c')
        @cart_a2_c = create(:cart, product_id: @product_a2.id, variant_id: @variant_a2_c.id, user_id: user.id)

        @product_a1 = create(:product, shop_id: @shop_a.id, name: 'product a1')
        @variant_a1_c = create(:product_variant, product_id: @product_a1.id, stock: 5, name: 'variant c')
        @variant_a1_a = create(:product_variant, product_id: @product_a1.id, stock: 5, name: 'variant a')
        @cart_a1_c = create(:cart, product_id: @product_a1.id, variant_id: @variant_a1_c.id, user_id: user.id)
        @cart_a1_a = create(:cart, product_id: @product_a1.id, variant_id: @variant_a1_a.id, user_id: user.id)

        params = {
          user_id: user.id
        }

        @status, @carts = Carts::Queries::All.current_user_cart(params)
      end

      it 'status should be :ok' do
        expect(@status).to eq(:ok)
      end

      it 'should return charts' do
        sorted_cart_ids = [@cart_a1_a.id, @cart_a1_c.id, @cart_a2_c.id, @cart_b1_b.id]
        expect(@carts.pluck(:id)).to eq(sorted_cart_ids)
      end
    end
  end
end
