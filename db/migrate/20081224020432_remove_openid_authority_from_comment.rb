class RemoveOpenidAuthorityFromComment < ActiveRecord::Migration
  def self.up
    remove_column :comments, :author_openid_authority
  end

  def self.down
    add_column :comments, :author_openid_authority, :string, :null => false
  end
end
