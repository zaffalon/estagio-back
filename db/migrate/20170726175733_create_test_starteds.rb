class CreateTestStarteds < ActiveRecord::Migration
  def change
    create_table :started_tests do |t|
      t.integer :user_id
      t.datetime :started_at
      t.datetime :start_until

      t.timestamps
    end
  end
end
