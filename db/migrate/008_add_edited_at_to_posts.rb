class AddEditedAtToPosts < ActiveRecord::Migration
  class Post < ActiveRecord::Base; end;

  def self.up
    add_column :posts, :edited_at, :datetime, :null => false
    Post.update_all('edited_at = updated_at')
  end

  def self.down
    remove_column :posts, :edited_at
  end
end
