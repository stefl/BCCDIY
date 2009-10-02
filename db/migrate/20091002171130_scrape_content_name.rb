class ScrapeContentName < ActiveRecord::Migration
  def self.up
    #remove_column :scrape_jobs, :content
    add_column :scrape_jobs, :scraped_content,:text
    
  end

  def self.down
  end
end
