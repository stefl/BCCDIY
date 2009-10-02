class ScrapeContent < ActiveRecord::Migration
  def self.up
    add_column :scrape_jobs, :content, :text
  end

  def self.down
    remove_column :scrape_jobs, :content
  end
end


