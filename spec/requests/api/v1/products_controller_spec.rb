require 'rails_helper'

RSpec.describe "Api::V1::ProductsControllers", type: :request do
  describe "GET /products" do
    context 'we have available products' do
      before do
        shop = create(:shop)
        @existing_products = create_list(:product, 2, shop_id: shop.id)

        get api_v1_products_path
      end

      it 'status should be 200' do
        expect(response.status).to eq(200)
      end

      it 'should return product data' do
        products = []
        @existing_products.each do |product|
          products << {
            id: product.id,
            name: product.name,
            description: product.description,
            average_rating: product.average_rating,
            status: product.status,
            formatted_price: "$#{(product.variants.minimum(:price_cents)/100)}",
            shop_information: {
              id: product.shop.id,
              address: product.shop.address,
              description: product.shop.description,
              shop_type: product.shop.shop_type
            }
          }
        end

        expectation = {products: products}.with_indifferent_access

        expect(json).to eq(expectation)
      end
    end
  end

  describe "GET /products/{id}" do
    context 'we have available products' do
      before do
        shop = create(:shop)
        @existing_product = create(:product, shop_id: shop.id)

        get api_v1_product_path(@existing_product.id)
      end

      it 'status should be 200' do
        expect(response.status).to eq(200)
      end

      it 'should response product details' do
        variants = []
        @existing_product.variants.each do |variant|
          variants << {
            id: variant.id,
            name: variant.name,
            formatted_price: "$#{variant.price}",
            stock: variant.stock
          }
        end

        expectation = {
          products: {
            id: @existing_product.id,
            name: @existing_product.name,
            description: @existing_product.description,
            average_rating: @existing_product.average_rating,
            status: @existing_product.status,
            formatted_price: "$#{(@existing_product.variants.minimum(:price_cents)/100)}",
            shop_information: {
              id: @existing_product.shop.id,
              address: @existing_product.shop.address,
              description: @existing_product.shop.description,
              shop_type: @existing_product.shop.shop_type
            },
            variants: variants
          }
        }.with_indifferent_access

        expect(json).to eq(expectation)
      end
    end

    context 'filter by shop type' do
      before do
        shop_bronze = create(:shop, shop_type: Shop::BRONZE)
        create_list(:product, 2, shop_id: shop_bronze.id)

        shop_gold = create(:shop, shop_type: Shop::GOLD)
        @products_gold = create_list(:product, 3, shop_id: shop_gold.id)

        get api_v1_products_path, params: {shop_type: Shop::GOLD}
      end

      it 'status should be 200' do
        expect(response.status).to eq(200)
      end

      it 'should return product data' do
        products = []
        @products_gold.each do |product|
          products << {
            id: product.id,
            name: product.name,
            description: product.description,
            average_rating: product.average_rating,
            status: product.status,
            formatted_price: "$#{(product.variants.minimum(:price_cents)/100)}",
            shop_information: {
              id: product.shop.id,
              address: product.shop.address,
              description: product.shop.description,
              shop_type: product.shop.shop_type
            }
          }
        end

        expectation = {products: products}.with_indifferent_access

        expect(json).to eq(expectation)
      end
    end

    context 'filter by product name' do
      before do
        shop_bronze = create(:shop, shop_type: Shop::BRONZE)
        create_list(:product, 2, shop_id: shop_bronze.id)

        product_name = 'Gantungan Kunci Spongebob-Patrick Lucu'
        shop_gold = create(:shop, shop_type: Shop::GOLD)
        create_list(:product, 3, shop_id: shop_gold.id)
        @product = create(:product, shop_id: shop_gold.id, name: product_name)

        get api_v1_products_path, params: {product_name: 'sponge'}
      end

      it 'status should be 200' do
        expect(response.status).to eq(200)
      end

      it 'should return product data' do
        products = [
          {
            id: @product.id,
            name: @product.name,
            description: @product.description,
            average_rating: @product.average_rating,
            status: @product.status,
            formatted_price: "$#{(@product.variants.minimum(:price_cents)/100)}",
            shop_information: {
              id: @product.shop.id,
              address: @product.shop.address,
              description: @product.shop.description,
              shop_type: @product.shop.shop_type
            }
          }
        ]

        expectation = {products: products}.with_indifferent_access

        expect(json).to eq(expectation)
      end
    end
  end
end
