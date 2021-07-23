require 'rails_helper'

RSpec.describe "Orders::Services::Create", type: :request do
  describe '.run' do
    context 'with valid params' do
      before do
        user = create(:user)
        shop = create(:shop)
        product = create(:product, shop_id: shop.id)
        variant = create(:product_variant, product_id: product.id, stock: 5)
        @cart1 = create(:cart, product_id: product.id, variant_id: variant.id, user_id: user.id, shop_id: shop.id)
        @cart2 = create(:cart, product_id: product.id, variant_id: product.variants.first.id, user_id: user.id, shop_id: shop.id)

        params = {cart_ids: [@cart1.id, @cart2.id]}

        @status, @orders = Orders::Services::Create.run(params, user)
      end

      it 'status should be :ok' do
        expect(@status).to eq(:ok)
      end

      it 'should create order based on given cart_ids' do
        expect(@orders.size).to eq(1)
        expect(@orders.first.persisted?).to eq(true)
        expect(@orders.first.snapshots.size).to eq(2)
      end

      it 'cart should not active anymore' do
        @cart1.reload
        @cart2.reload
        expect(@cart1.status).not_to eq('active')
        expect(@cart2.status).not_to eq('active')
      end
    end

    context 'multiple products in different shop' do
      before do
        user = create(:user)
        shop_a = create(:shop)
        product_a = create(:product, shop_id: shop_a.id)
        variant_a_a = create(:product_variant, product_id: product_a.id, stock: 5)
        @cart1 = create(:cart, product_id: product_a.id, variant_id: variant_a_a.id, user_id: user.id, shop_id: shop_a.id)
        @cart2 = create(:cart, product_id: product_a.id, variant_id: product_a.variants.first.id, user_id: user.id, shop_id: shop_a.id)

        shop_b = create(:shop)
        product_b = create(:product, shop_id: shop_b.id)
        variant_b_a = create(:product_variant, product_id: product_a.id, stock: 5)
        @cart3 = create(:cart, product_id: product_b.id, variant_id: variant_b_a.id, user_id: user.id, shop_id: shop_b.id)

        params = {cart_ids: [@cart1.id, @cart2.id, @cart3.id]}

        @status, @orders = Orders::Services::Create.run(params, user)
      end

      it 'status should be :ok' do
        expect(@status).to eq(:ok)
      end

      it 'should create order based on given cart_ids' do
        expect(@orders.size).to eq(2)
        expect(@orders.map{|o| o.persisted?}).to eq([true, true])

        snapshot_count = @orders.first.snapshots.size + @orders.last.snapshots.size
        expect(snapshot_count).to eq(3)
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
