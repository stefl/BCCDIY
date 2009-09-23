class AddUsers < ActiveRecord::Migration
  def self.up
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
    end

    add_index "users", ["last_seen_at"], :name => "index_users_on_last_seen_at"
    add_index "users", ["site_id", "permalink"], :name => "index_site_users_on_permalink"
    add_index "users", ["site_id", "posts_count"], :name => "index_site_users_on_posts_count"
    
    
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
    
    create_table "brain_busters", :force => true do |t|
      t.string "question"
      t.string "answer"
    end
  end

  def self.down
    drop_table "users"
  end
end
