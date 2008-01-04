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

ActiveRecord::Schema.define(:version => 3) do

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

  create_table "pages", :force => true do |t|
    t.string   "title",      :default => "", :null => false
    t.string   "slug",       :default => "", :null => false
    t.text     "body",       :default => "", :null => false
    t.text     "body_html",  :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.string   "title",                   :default => "",   :null => false
    t.string   "slug",                    :default => "",   :null => false
    t.text     "body",                    :default => "",   :null => false
    t.text     "body_html",               :default => "",   :null => false
    t.boolean  "active",                  :default => true, :null => false
    t.integer  "approved_comments_count",                   :null => false
    t.string   "cached_tag_list"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

end
