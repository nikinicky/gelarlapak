class CreateOrderSnapshots < ActiveRecord::Migration[5.2]
  def change
    create_table :order_snapshots do |t|
      t.integer :order_id
      t.integer :product_id
      t.integer :variant_id
      t.integer :quantity
      t.monetize :price

      t.timestamps
    end
  end
end
