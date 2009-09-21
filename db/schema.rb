# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090921142748) do

  create_table "committees", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "openly_local_committee_id"
  end

  create_table "constituencies", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "permalink"
    t.integer  "openly_local_constituency_id"
  end

  create_table "councils", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "daily_feeds", :force => true do |t|
    t.string   "url"
    t.text     "items"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.text     "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "openly_local_member_id"
  end

  create_table "pages", :force => true do |t|
    t.string   "url"
    t.text     "page_source"
    t.string   "title"
    t.string   "keywords"
    t.string   "description"
    t.string   "categories"
    t.text     "breadcrumb"
    t.text     "content"
    t.string   "parent_url"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "alias_id"
    t.boolean  "alias",       :default => false
    t.string   "slug"
  end

  add_index "pages", ["slug"], :name => "index_pages_on_slug"
  add_index "pages", ["title"], :name => "index_pages_on_title"

  create_table "wards", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "constituency_id"
    t.string   "permalink"
    t.integer  "openly_local_ward_id"
  end

end
