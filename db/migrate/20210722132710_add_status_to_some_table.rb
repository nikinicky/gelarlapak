class AddStatusToSomeTable < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :status, :string
    add_column :products, :status, :string
    add_column :product_variants, :status, :string
  end
end
