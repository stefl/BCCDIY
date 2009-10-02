class JobScrape < ActiveRecord::Migration
  def self.up
    create_table :scrape_jobs do |t|
      t.string :model
      t.string :url
    end
    add_column :jobs, :url, :string
  end

  def self.down
    drop_table :scrape_jobs
    remove_column :jobs, :url
  end
end
