class CreateShops < ActiveRecord::Migration[5.2]
  def change
    create_table :shops do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.text :description
      t.string :shop_type

      t.timestamps
    end
  end
end
