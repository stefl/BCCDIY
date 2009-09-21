class CreateDailyFeeds < ActiveRecord::Migration
  def self.up
    create_table :daily_feeds do |t|
      t.string :url
      t.text :items
      t.timestamps
    end
  end

  def self.down
    drop_table :daily_feeds
  end
end
