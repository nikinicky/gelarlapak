class ChangeColumnPasswordInUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :password_digest, :encrypted_password
  end
end
