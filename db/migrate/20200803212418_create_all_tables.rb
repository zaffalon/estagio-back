class CreateAllTables < ActiveRecord::Migration[6.0]
  def change
    create_table "cards", id: false, force: :cascade do |t|
      t.string   "uid",        limit: 255
      t.string   "name",       limit: 255
      t.string   "number",     limit: 255
      t.string   "brand",      limit: 255
      t.string   "exp_year",   limit: 255
      t.string   "exp_month",  limit: 255
      t.float    "limit",      limit: 24
      t.integer  "user_id",    limit: 4
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "deleted_at"
    end
  
    create_table "payments", id: false, force: :cascade do |t|
      t.string   "uid",        limit: 255
      t.string   "card_id",    limit: 255
      t.string   "status",     limit: 255
      t.datetime "date"
      t.float    "amount",     limit: 24
      t.integer  "user_id",    limit: 4
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "deleted_at"
    end
  
    create_table "requests", id: false, force: :cascade do |t|
      t.string   "uid",              limit: 255
      t.string   "api_key",          limit: 255
      t.string   "http_method",      limit: 255
      t.string   "url",              limit: 500
      t.text     "user_agent",       limit: 65535
      t.string   "ip_address",       limit: 255
      t.text     "headers",          limit: 65535
      t.text     "post_params",      limit: 65535
      t.text     "get_params",       limit: 65535
      t.integer  "response_status",  limit: 4
      t.text     "response_headers", limit: 65535
      t.text     "response_body",    limit: 65535
      t.boolean  "success",                        null: false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "deleted_at"
    end
  
    add_index "requests", ["api_key"], name: "index_requests_on_api_key", using: :btree
    add_index "requests", ["deleted_at"], name: "index_requests_on_deleted_at", using: :btree
  
    create_table "started_tests", force: :cascade do |t|
      t.integer  "user_id",      limit: 4
      t.datetime "started_at"
      t.datetime "finish_until"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    create_table "user_tokens", force: :cascade do |t|
      t.string   "user_id",         limit: 255
      t.string   "token",           limit: 255, null: false
      t.datetime "expiry_at"
      t.string   "user_agent",      limit: 255
      t.string   "create_ip",       limit: 255
      t.string   "last_request_ip", limit: 255
      t.datetime "last_request_at"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  
    create_table "users", force: :cascade do |t|
      t.string   "email",             limit: 255
      t.string   "name",              limit: 255
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "persistence_token", limit: 255
      t.string   "perishable_token",  limit: 255
      t.integer  "login_count",       limit: 4,   default: 0,     null: false
      t.string   "current_login_ip",  limit: 255
      t.string   "last_login_ip",     limit: 255
      t.datetime "start_test_until"
      t.boolean  "admin",                         default: false
    end
  
  end
end
