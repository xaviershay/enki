# Use this migration to create the tables for the ActiveRecord store
class AddOpenIdStoreToDb < ActiveRecord::Migration
  def self.up
    create_table "open_id_associations", :force => true do |t|
      t.column "server_url", :binary
      t.column "handle", :string
      t.column "secret", :binary
      t.column "issued", :integer
      t.column "lifetime", :integer
      t.column "assoc_type", :string
    end

    create_table "open_id_nonces", :force => true do |t|
      t.column :server_url, :string, :null => false
      t.column :timestamp, :integer, :null => false
      t.column :salt, :string, :null => false
    end
  end

  def self.down
    drop_table "open_id_associations"
    drop_table "open_id_nonces"
  end
end
