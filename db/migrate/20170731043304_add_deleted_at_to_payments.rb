class AddDeletedAtToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :deleted_at, :datetime, index: true
  end
end
