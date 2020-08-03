class AddCards < ActiveRecord::Migration
  def change
    create_table :cards, id: false  do |t|
      t.string :uid, primary_key: true
      t.string    :name
      t.string    :number
      t.string    :brand
      t.string   :exp_year
      t.string   :exp_month
      t.float    :limit, :precision => 5, :scale => 2
      t.integer :user_id

      t.timestamps
    end

    create_table :payments, id: false  do |t|
      t.string :uid, primary_key: true
      t.string    :card_id
      t.string    :status
      t.datetime  :date
      t.float    :amount, :precision => 5, :scale => 2
      t.integer :user_id

      t.timestamps
    end

  end
end
