class InitializeDb < ActiveRecord::Migration
  def self.up
    create_table "comments" do |t|
      t.integer  "post_id",                 :null => false
      t.string   "author",                  :null => false
      t.string   "author_url",              :null => false
      t.string   "author_email",            :null => false
      t.string   "author_openid_authority", :null => false
      t.text     "body",                    :null => false
      t.text     "body_html",               :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "comments", ["post_id"], :name => "index_comments_on_post_id"
    add_index "comments", ["created_at"], :name => "index_comments_on_created_at"

    create_table "open_id_authentication_associations" do |t|
      t.integer "issued"
      t.integer "lifetime"
      t.string  "handle"
      t.string  "assoc_type"
      t.binary  "server_url"
      t.binary  "secret"
    end

    create_table "open_id_authentication_nonces" do |t|
      t.integer "timestamp",  :null => false
      t.string  "server_url"
      t.string  "salt",       :null => false
    end

    create_table "pages" do |t|
      t.string   "title",      :null => false
      t.string   "slug",       :null => false
      t.text     "body",       :null => false
      t.text     "body_html",  :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "pages", ["title"], :name => "index_pages_on_title"
    add_index "pages", ["created_at"], :name => "index_pages_on_created_at"

    create_table "posts" do |t|
      t.string   "title",                                                      :null => false
      t.string   "slug",                                                       :null => false
      t.text     "body",                                                       :null => false
      t.text     "body_html",                                                  :null => false
      t.boolean  "active",                  :default => true,                  :null => false
      t.integer  "approved_comments_count", :default => 0,                     :null => false
      t.string   "cached_tag_list"
      t.datetime "published_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.datetime "edited_at",                                                  :null => false
    end

    add_index "posts", ["published_at"], :name => "index_posts_on_published_at"

    create_table "sessions" do |t|
      t.string   "session_id", :null => false
      t.text     "data"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"
    add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

    create_table "taggings" do |t|
      t.integer  "tag_id"
      t.integer  "taggable_id"
      t.datetime "created_at"
    end

    add_index "taggings", ["taggable_id"], :name => "index_taggings_on_taggable_id_and_taggable_type"
    add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"

    create_table "tags" do |t|
      t.string  "name"
      t.integer "taggings_count", :default => 0, :null => false
    end

    add_index "tags", ["name"], :name => "index_tags_on_name"

    create_table "undo_items" do |t|
      t.string   "type",       :null => false
      t.datetime "created_at", :null => false
      t.text     "data"
    end

    add_index "undo_items", ["created_at"], :name => "index_undo_items_on_created_at"
  end

  def self.down
    raise IrreversibleMigration
  end
end
