class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :code, null: false
      t.string :status, default: 'pending'
      t.integer :user_id

      t.timestamps
    end
  end
end
