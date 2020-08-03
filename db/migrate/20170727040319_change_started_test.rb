class ChangeStartedTest < ActiveRecord::Migration
  def change
    rename_column :started_tests, :start_until, :finish_until
  end
end
