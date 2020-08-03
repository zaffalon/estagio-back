class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests, id: false do |t|
      t.string :uid, primary_key: true
      t.string :api_key, index: true
      t.string :http_method
      t.string :url, limit: 500
      t.text :user_agent
      t.string :ip_address
      t.text :headers
      t.text :post_params
      t.text :get_params
      t.integer :response_status
      t.text :response_headers
      t.text :response_body
      t.boolean :success, null: false

      t.timestamps
      t.datetime :deleted_at, index: true
    end
  end
end
