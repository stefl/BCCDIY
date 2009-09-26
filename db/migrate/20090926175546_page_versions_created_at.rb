class PageVersionsCreatedAt < ActiveRecord::Migration
  def self.up
    # set the timestamp to the time we run the migration... messy. Shame it wasn't in there to start with
    add_column :page_versions, :updated_at, :timestamp, :default=>Time.now
  end

  def self.down
    remove_column :page_versions, :updated_at
  end
end
