class AddStartTestUntilToUsers < ActiveRecord::Migration
  def change
    add_column :users, :start_test_until, :datetime
  end
end
