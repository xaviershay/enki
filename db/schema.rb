# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 8) do

  create_table "comments", :force => true do |t|
    t.integer  "post_id",                                    :null => false
    t.string   "author",                  :default => "",    :null => false
    t.string   "author_url",              :default => "",    :null => false
    t.string   "author_email",            :default => "",    :null => false
    t.string   "author_openid_authority", :default => "",    :null => false
    t.text     "body",                    :default => "",    :null => false
    t.text     "body_html",               :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "spam",                    :default => false
    t.float    "spaminess"
    t.string   "signature"
  end

  add_index "comments", ["created_at"], :name => "index_comments_on_created_at"
  add_index "comments", ["post_id"], :name => "index_comments_on_post_id"

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",                  :null => false
    t.string  "server_url"
    t.string  "salt",       :default => "", :null => false
  end

  create_table "pages", :force => true do |t|
    t.string   "title",      :default => "", :null => false
    t.string   "slug",       :default => "", :null => false
    t.text     "body",       :default => "", :null => false
    t.text     "body_html",  :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["created_at"], :name => "index_pages_on_created_at"
  add_index "pages", ["title"], :name => "index_pages_on_title"

  create_table "posts", :force => true do |t|
    t.string   "title",                   :default => "",   :null => false
    t.string   "slug",                    :default => "",   :null => false
    t.text     "body",                    :default => "",   :null => false
    t.text     "body_html",               :default => "",   :null => false
    t.boolean  "active",                  :default => true, :null => false
    t.integer  "approved_comments_count", :default => 0,    :null => false
    t.string   "cached_tag_list"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "edited_at",                                 :null => false
  end

  add_index "posts", ["published_at"], :name => "index_posts_on_published_at"

  create_table "schema_migrations", :primary_key => "version", :force => true do |t|
  end

  add_index "schema_migrations", ["version"], :name => "unique_schema_migrations", :unique => true

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :default => "", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "taggings_count", :default => 0, :null => false
  end

  add_index "tags", ["name"], :name => "index_tags_on_name"

end
