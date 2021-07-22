require 'rails_helper'

RSpec.describe "Api::V1::Carts", type: :request do
  describe "POST /api/v1/carts" do
    context 'with valid params' do
      before do
        user = create(:user)
        token = encode_token(user)
        headers = {Authorization: "Bearer #{token}"}

        shop = create(:shop)
        product = create(:product, shop_id: shop.id)

        params = {
          product_id: product.id,
          variant_id: product.variants.first.id,
          quantity: 1,
          description: Faker::Lorem.paragraph,
          user_id: user.id
        }

        post api_v1_carts_path, params: params, headers: headers
      end

      it 'status should be 200' do
        expect(response.status).to eq(200)
      end

      it 'should add the product to the cart' do
        expectation = {success: true}.with_indifferent_access
        expect(json).to eq(expectation)
      end
    end

    context 'product is unavailable' do
      before do
        user = create(:user)
        token = encode_token(user)
        headers = {Authorization: "Bearer #{token}"}

        shop = create(:shop)
        product = create(:product, shop_id: shop.id)
        variant = create(:product_variant, product_id: product.id, stock: 0)

        params = {
          product_id: product.id,
          variant_id: variant.id,
          quantity: 1,
          description: Faker::Lorem.paragraph,
          user_id: user.id
        }

        post api_v1_carts_path, params: params, headers: headers
      end

      it 'status should be 422' do
        expect(response.status).to eq(422)
      end

      it 'should not add the product to the cart' do
        expectation = {
          success: false,
          message: "Your selected item is unavailable."
        }.with_indifferent_access

        expect(json).to eq(expectation)
      end
    end
  end

  describe "GET /api/v1/carts" do
    context 'with valid params' do
      before do
        user = create(:user)
        token = encode_token(user)
        headers = {Authorization: "Bearer #{token}"}

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

        get api_v1_carts_path, headers: headers
      end

      it 'status should be 200' do
        expect(response.status).to eq(200)
      end

      it 'should return cart data' do
        cart_shop_a = [@cart_a1_a, @cart_a1_c, @cart_a2_c]

        shop = @cart_a1_a.product.shop
        expectation = {
          carts: [
            {
              shop_info: {
                id: shop.id,
                name: shop.name,
                address: shop.address,
                shop_type: shop.shop_type
              }
            }
          ]
        }
        products = []

        cart_shop_a.each do |cart|
          products << {
            cart_id: cart.id,
            product_id: cart.product.id,
            variant_id: cart.variant_id,
            name: cart.product.name,
            variant: cart.variant.name,
            price: cart.variant.price.to_f,
            formatted_price: "$#{cart.variant.price}",
            quantity: cart.quantity,
            stock: cart.variant.stock,
            note: cart.description
          }
        end

        expectation[:carts].first[:products] = products

        shop = @cart_b1_b.product.shop
        expectation[:carts] << {
          shop_info: {
            id: shop.id,
            name: shop.name,
            address: shop.address,
            shop_type: shop.shop_type
          },
          products: [
            {
              cart_id: @cart_b1_b.id,
              product_id: @cart_b1_b.product.id,
              variant_id: @cart_b1_b.variant_id,
              name: @cart_b1_b.product.name,
              variant: @cart_b1_b.variant.name,
              price: @cart_b1_b.variant.price.to_f,
              formatted_price: "$#{@cart_b1_b.variant.price}",
              quantity: @cart_b1_b.quantity,
              stock: @cart_b1_b.variant.stock,
              note: @cart_b1_b.description
            }
          ]
        }

        expect(json).to eq(expectation.with_indifferent_access)
      end
    end
  end

  describe "PATCH /api/v1/cart/{:id}" do
    context 'with valid params' do
      context 'update quantity' do
        before do
          user = create(:user)
          token = encode_token(user)
          headers = {Authorization: "Bearer #{token}"}

          shop = create(:shop)
          product = create(:product, shop_id: shop.id)
          variant = create(:product_variant, product_id: product.id, stock: 5)
          @cart = create(:cart, product_id: product.id, variant_id: variant.id, user_id: user.id, quantity: 1)

          params = {quantity: 2}

          patch api_v1_cart_path(@cart.id), params: params, headers: headers
        end

        it 'status should be 200' do
          expect(response.status).to eq(200)
        end

        it 'should update the quantity' do
          @cart.reload
          expect(@cart.quantity).to eq(2)
        end
      end

      context 'delete product from cart' do
        before do
          user = create(:user)
          token = encode_token(user)
          headers = {Authorization: "Bearer #{token}"}

          shop = create(:shop)
          product = create(:product, shop_id: shop.id)
          variant = create(:product_variant, product_id: product.id, stock: 5)
          @cart = create(:cart, product_id: product.id, variant_id: variant.id, user_id: user.id, quantity: 1)

          params = {status: 'deleted'}

          patch api_v1_cart_path(@cart.id), params: params, headers: headers
        end

        it 'status should be 200' do
          expect(response.status).to eq(200)
        end

        it 'should update the quantity' do
          @cart.reload
          expect(@cart.status).to eq('deleted')
        end
      end
    end

    context 'with invalid params' do
      context 'update quantity more than product stock' do
        before do
          user = create(:user)
          token = encode_token(user)
          headers = {Authorization: "Bearer #{token}"}

          shop = create(:shop)
          product = create(:product, shop_id: shop.id)
          variant = create(:product_variant, product_id: product.id, stock: 5)
          @cart = create(:cart, product_id: product.id, variant_id: variant.id, user_id: user.id, quantity: 1)

          params = {quantity: 6}

          patch api_v1_cart_path(@cart.id), params: params, headers: headers
        end

        it 'status should be 422' do
          expect(response.status).to eq(422)
        end

        it 'should not update the quantity' do
          @cart.reload
          expect(@cart.quantity).to eq(1)
        end

        it 'should return error message' do
          expectation = {
            success: false,
            message: "Your selected item is unavailable."
          }.with_indifferent_access

          expect(json).to eq(expectation)
        end
      end
    end
  end
end
