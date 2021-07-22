class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :shop_id, null: false
      t.text :description
      t.float :average_rating

      t.timestamps
    end
  end
end
