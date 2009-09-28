class LongerUrls < ActiveRecord::Migration
  def self.up
    change_column :planning_applications, :info_url, :text
  end

  def self.down
    change_column :planning_applications, :info_url, :string
  end
end
