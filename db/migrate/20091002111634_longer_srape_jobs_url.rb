class LongerSrapeJobsUrl < ActiveRecord::Migration
  def self.up
    change_column :scrape_jobs, :url, :text
    
  end

  def self.down
    change_column :scrape_jobs, :url, :string
    
  end
end
