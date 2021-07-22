class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.integer :product_id, null: false
      t.integer :variant_id, null: false
      t.integer :quantity, null: false
      t.text :description
      t.string :status

      t.timestamps
    end
  end
end
