class CreateNewTables < ActiveRecord::Migration
  def change
    create_table "user_tokens", force: true do |t|
      t.string   "user_id"
      t.string   "token",           null: false
      t.datetime "expiry_at"
      t.string   "user_agent"
      t.string   "create_ip"
      t.string   "last_request_ip"
      t.datetime   "last_request_at"

      t.timestamps
    end

    create_table "users", force: true do |t|
      t.string   "email"
      t.string   "name"

      t.timestamps
    end

  end
end
