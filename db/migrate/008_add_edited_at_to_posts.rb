class AddEditedAtToPosts < ActiveRecord::Migration
  class Post < ActiveRecord::Base; end;

  def self.up
    # this is a bogus default to keep SQLite happy, remove it when we collapse migrations
    add_column :posts, :edited_at, :datetime, :null => false, :default => Time.now 
    Post.update_all('edited_at = updated_at')
  end

  def self.down
    remove_column :posts, :edited_at
  end
end
