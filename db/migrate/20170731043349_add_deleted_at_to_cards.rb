class AddDeletedAtToCards < ActiveRecord::Migration
  def change
    add_column :cards, :deleted_at, :datetime, index: true
  end
end
