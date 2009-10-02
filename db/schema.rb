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

ActiveRecord::Schema.define(:version => 20091002111340) do

  create_table "brain_busters", :force => true do |t|
    t.string "question"
    t.string "answer"
  end

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

  create_table "jobs", :force => true do |t|
    t.string   "title"
    t.text     "service_area"
    t.integer  "salary_low"
    t.integer  "salary_high"
    t.string   "salary"
    t.string   "reference"
    t.string   "contract_type"
    t.date     "closing_date"
    t.boolean  "cbi_check"
    t.string   "cbi_check_text"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "url"
    t.string   "directorate"
  end

  create_table "members", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "openly_local_member_id"
  end

  create_table "open_id_authentication_associations", :force => true do |t|
    t.binary  "server_url"
    t.string  "handle"
    t.binary  "secret"
    t.integer "issued"
    t.integer "lifetime"
    t.string  "assoc_type"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.string  "nonce"
    t.integer "created"
  end

  create_table "open_id_authentication_settings", :force => true do |t|
    t.string "setting"
    t.binary "value"
  end

  create_table "page_versions", :force => true do |t|
    t.integer  "page_id"
    t.integer  "version"
    t.string   "title"
    t.string   "keywords"
    t.string   "description"
    t.string   "categories"
    t.text     "content"
    t.integer  "parent_id"
    t.integer  "alias_id"
    t.boolean  "alias",       :default => false
    t.string   "slug"
    t.boolean  "is_textile",  :default => false
    t.integer  "user_id",     :default => 1
    t.datetime "updated_at",  :default => '2009-09-26 19:01:37'
  end

  add_index "page_versions", ["page_id"], :name => "index_page_versions_on_page_id"

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
    t.integer  "version"
    t.boolean  "is_textile",  :default => false
    t.integer  "user_id",     :default => 1
    t.boolean  "favorite",    :default => false
  end

  add_index "pages", ["slug"], :name => "index_pages_on_slug"
  add_index "pages", ["title"], :name => "index_pages_on_title"

  create_table "planning_applications", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "council_reference"
    t.string   "council_id"
    t.string   "address"
    t.string   "postcode"
    t.text     "description"
    t.text     "info_url"
    t.string   "comment_url"
    t.date     "date_received"
    t.integer  "ward_id"
  end

  create_table "revisions", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scrape_jobs", :force => true do |t|
    t.string   "model"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tools", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "url"
    t.text     "description"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                   :default => "passive"
    t.datetime "deleted_at"
    t.boolean  "admin",                                   :default => false
    t.integer  "site_id"
    t.datetime "last_login_at"
    t.text     "bio_html"
    t.string   "openid_url"
    t.datetime "last_seen_at"
    t.string   "website"
    t.integer  "posts_count",                             :default => 0
    t.string   "bio"
    t.string   "display_name"
    t.string   "permalink"
    t.string   "twitter"
    t.string   "postcode"
  end

  add_index "users", ["last_seen_at"], :name => "index_users_on_last_seen_at"
  add_index "users", ["site_id", "permalink"], :name => "index_site_users_on_permalink"
  add_index "users", ["site_id", "posts_count"], :name => "index_site_users_on_posts_count"

  create_table "wards", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "constituency_id"
    t.string   "permalink"
    t.integer  "openly_local_ward_id"
  end

end
