class AddUndoItemsTable < ActiveRecord::Migration
  def self.up
    create_table :undo_items do |t|
      t.string   :type,       :null => false
      t.datetime :created_at, :null => false
      t.text     :data
    end

    add_index :undo_items, :created_at
  end

  def self.down
    drop_table :undo_items
  end
end
