class AddAuthlogicFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :persistence_token, :string, index: true, unique: true
    add_column :users, :perishable_token, :string, index: true, unique: true
    add_column :users, :login_count, :integer, default: 0, null: false
    add_column :users, :current_login_ip, :string
    add_column :users, :last_login_ip, :string

  end
end
