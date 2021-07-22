class CreateProductVariants < ActiveRecord::Migration[5.2]
  def change
    create_table :product_variants do |t|
      t.integer :product_id, null: false
      t.string :name, null: false
      t.monetize :price
      t.integer :stock

      t.timestamps
    end
  end
end
