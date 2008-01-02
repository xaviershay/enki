class AddDefensioColumnsToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :spam,      :boolean, :default => false
    add_column :comments, :spaminess, :float
    add_column :comments, :signature, :string
  end

  def self.down
    remove_column :comments, :spam
    remove_column :comments, :spaminess
    remove_column :comments, :signature
  end
end
