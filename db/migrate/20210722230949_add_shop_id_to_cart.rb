class AddShopIdToCart < ActiveRecord::Migration[5.2]
  def change
    add_column :carts, :shop_id, :integer
  end
end
