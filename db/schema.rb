# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151220095617) do

  create_table "comments", force: :cascade do |t|
    t.integer  "post_id",      null: false
    t.string   "author",       null: false
    t.string   "author_url",   null: false
    t.string   "author_email", null: false
    t.text     "body",         null: false
    t.text     "body_html",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["created_at"], name: "index_comments_on_created_at"
  add_index "comments", ["post_id"], name: "index_comments_on_post_id"

  create_table "omni_auth_details", force: :cascade do |t|
    t.string   "provider",    null: false
    t.string   "uid"
    t.text     "info"
    t.text     "credentials"
    t.text     "extra"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title",      null: false
    t.string   "slug",       null: false
    t.text     "body",       null: false
    t.text     "body_html",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["created_at"], name: "index_pages_on_created_at"
  add_index "pages", ["slug"], name: "pages_slug_unique_idx"
  add_index "pages", ["title"], name: "index_pages_on_title"

  create_table "posts", force: :cascade do |t|
    t.string   "title",                                  null: false
    t.string   "slug",                                   null: false
    t.text     "body",                                   null: false
    t.text     "body_html",                              null: false
    t.boolean  "active",                  default: true, null: false
    t.integer  "approved_comments_count", default: 0,    null: false
    t.string   "cached_tag_list"
    t.datetime "published_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "edited_at",                              null: false
  end

  add_index "posts", ["published_at"], name: "index_posts_on_published_at"
  add_index "posts", ["slug"], name: "posts_slug_unique_idx"

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.datetime "created_at"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type",             null: false
    t.string   "context",       limit: 128, null: false
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true

  create_table "undo_items", force: :cascade do |t|
    t.string   "type",       null: false
    t.datetime "created_at", null: false
    t.text     "data"
  end

  add_index "undo_items", ["created_at"], name: "index_undo_items_on_created_at"

end
