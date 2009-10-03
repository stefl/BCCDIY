class AddIndexesForDailyFeeds < ActiveRecord::Migration
  def self.up
    add_index :daily_feeds, [:created_at, :url]
    
  end

  def self.down
    remove_index :daily_feeds, [:created_at, :url]
    
  end
end
