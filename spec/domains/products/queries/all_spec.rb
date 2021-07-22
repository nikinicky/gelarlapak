require 'rails_helper'

RSpec.describe "Products::Queries::All", type: :request do
  describe '.run' do
    context 'we have some products' do
      before do
        shop = create(:shop)
        @existing_products = create_list(:product, 5, shop_id: shop.id)

        @status, @products = Products::Queries::All.run({})
      end

      it 'status should be :ok' do
        expect(@status).to eq(:ok)
      end

      it 'should return all available products' do
        expect(@products.size).to eq(@existing_products.size)
      end
    end

    context 'filter by shop type' do
      before do
        shop_bronze = create(:shop, shop_type: Shop::BRONZE)
        create(:product, shop_id: shop_bronze.id)

        shop_gold = create(:shop, shop_type: Shop::GOLD)
        create_list(:product, 3, shop_id: shop_gold.id)

        @status, @products = Products::Queries::All.run({shop_type: Shop::GOLD})
      end

      it 'status should be :ok' do
        expect(@status).to eq(:ok)
      end

      it "should only return product from GOLD type shop" do
        expect(@products.size).to eq(3)
      end
    end
  end
end
