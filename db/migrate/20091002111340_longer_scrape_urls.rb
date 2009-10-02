class LongerScrapeUrls < ActiveRecord::Migration
  def self.up
    change_column :jobs, :url, :text
    
  end

  def self.down
    change_column :jobs, :url, :string
    
  end
end
