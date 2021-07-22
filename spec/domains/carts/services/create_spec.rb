require 'rails_helper'

RSpec.describe "Carts::Services::Create", type: :request do
  describe '.run' do
    context 'with valid params' do
      before do
        user = create(:user)
        shop = create(:shop)
        @product = create(:product, shop_id: shop.id)

        params = {
          product_id: @product.id,
          variant_id: @product.variants.first.id,
          quantity: 1,
          description: Faker::Lorem.paragraph,
          user_id: user.id
        }

        @status, @cart = Carts::Services::Create.run(params)
      end

      it 'status should be :ok' do
        expect(@status).to eq(:ok)
      end

      it 'should create cart' do
        expect(@cart.persisted?).to eq(true)
      end
    end

    context 'if quantity more than stock' do
      before do
        user = create(:user)
        shop = create(:shop)
        @product = create(:product, shop_id: shop.id)
        @variant = create(:product_variant, product_id: @product.id, stock: 0)

        params = {
          product_id: @product.id,
          variant_id: @variant.id,
          quantity: 1,
          description: Faker::Lorem.paragraph,
          user_id: user.id
        }

        @status, @cart = Carts::Services::Create.run(params)
      end

      it 'status should be :unavailable' do
        expect(@status).to eq(:unavailable)
      end

      it 'should create cart' do
        expect(@cart.persisted?).to eq(false)
      end
    end
  end
end
