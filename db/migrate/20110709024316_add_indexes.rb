class AddIndexes < ActiveRecord::Migration
  def change
    add_index :posts, :slug, :name => 'posts_slug_unique_idx'
    add_index :pages, :slug, :name => 'pages_slug_unique_idx'
  end
end
