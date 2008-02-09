class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :posts, :published_at
    add_index :pages, :created_at
    add_index :pages, :title
    add_index :comments, :created_at
    add_index :comments, :post_id
    add_index :tags, :name
  end

  def self.down
    remove_index :posts, :published_at
    remove_index :pages, :created_at
    remove_index :pages, :title
    remove_index :comments, :created_at
    remove_index :comments, :post_id
    remove_index :tags, :name
  end
end
