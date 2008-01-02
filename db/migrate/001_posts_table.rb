class PostsTable < ActiveRecord::Migration
  def self.up
    create_table :posts do |table|
      table.with_options(:null => false) do |t|
        t.string :title
        t.string :slug

        t.text   :body
        t.text   :body_html

        t.boolean :active, :default => true

        t.integer :approved_comments_count
      end

      table.timestamps
    end

    create_table :comments do |table|
      table.with_options(:null => false) do |t|
        t.integer :post_id

        t.string :author
        t.string :author_url
        t.string :author_email
        t.string :author_openid_authority

        t.text :body
        t.text :body_html
      end

      table.timestamps
    end

    create_table :pages do |table|
      table.with_options(:null => false) do |t|
        t.string :title
        t.string :slug

        t.text   :body
        t.text   :body_html
      end

      table.timestamps
    end
  end

  def self.down
    drop_table :comments
    drop_table :posts
  end
end
