class RemoveOpenidAuthorityFromComment < ActiveRecord::Migration
  def up
    remove_column :comments, :author_openid_authority
  end

  def down
    add_column :comments, :author_openid_authority, :string, :null => false
  end
end
