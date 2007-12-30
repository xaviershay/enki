class AddDefensioColumnsTo<%= class_name %> < ActiveRecord::Migration
  def self.up
    add_column :<%= table_name %>, :spam,      :boolean, :default => false
    add_column :<%= table_name %>, :spaminess, :float
    add_column :<%= table_name %>, :signature, :string
    # Uncomment this if you wanna customize when an article is announced to Defensio server
    # add_column :article, :announced, :boolean, :default => false
  end

  def self.down
    remove_column :<%= table_name %>, :spam
    remove_column :<%= table_name %>, :spaminess
    remove_column :<%= table_name %>, :signature
    # add_column :article, :announced
  end
end
