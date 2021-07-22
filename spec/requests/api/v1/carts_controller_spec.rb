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
end
