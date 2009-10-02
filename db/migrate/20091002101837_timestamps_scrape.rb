class TimestampsScrape < ActiveRecord::Migration
  def self.up
    add_column :scrape_jobs, :created_at, :timestamp
    add_column :scrape_jobs, :updated_at, :timestamp
  end

  def self.down
    remove_column :scrape_jobs, :created_at
    remove_column :scrape_jobs, :updated_at
  end
end
