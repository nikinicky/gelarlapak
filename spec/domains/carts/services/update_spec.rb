require 'rails_helper'

RSpec.describe "Carts::Services::Update", type: :request do
  describe '.run' do
    context 'with valid params' do
      context 'change quantity' do
        before do
          user = create(:user)
          shop = create(:shop)
          product = create(:product, shop_id: shop.id)
          variant = create(:product_variant, product_id: product.id, stock: 5)
          cart = create(:cart, product_id: product.id, variant_id: variant.id, user_id: user.id, quantity: 1)

          params = {quantity: 2}

          @status, @cart = Carts::Services::Update.run(cart, params)
        end

        it 'status should be :ok' do
          expect(@status).to eq(:ok)
        end

        it 'should update the quantity' do
          expect(@cart.quantity).to eq(2)
        end
      end

      context 'delete product from cart' do
        before do
          user = create(:user)
          shop = create(:shop)
          product = create(:product, shop_id: shop.id)
          variant = create(:product_variant, product_id: product.id, stock: 5)
          cart = create(:cart, product_id: product.id, variant_id: variant.id, user_id: user.id, quantity: 1)

          params = {status: 'deleted'}

          @status, @cart = Carts::Services::Update.run(cart, params)
        end

        it 'status should be :ok' do
          expect(@status).to eq(:ok)
        end

        it 'should update the quantity' do
          expect(@cart.status).to eq('deleted')
        end
      end
    end

    context 'with invalid params' do
      context 'change quantity to more than stock' do
        before do
          user = create(:user)
          shop = create(:shop)
          product = create(:product, shop_id: shop.id)
          variant = create(:product_variant, product_id: product.id, stock: 5)
          cart = create(:cart, product_id: product.id, variant_id: variant.id, user_id: user.id, quantity: 1)

          params = {quantity: 6}

          @status, @cart = Carts::Services::Update.run(cart, params)
        end

        it 'status should be :unavailable' do
          expect(@status).to eq(:unavailable)
        end

        it 'should not update the quantity' do
          expect(@cart.quantity).to eq(1)
        end
      end
    end
  end
end
