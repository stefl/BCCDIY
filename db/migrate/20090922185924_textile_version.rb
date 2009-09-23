class TextileVersion < ActiveRecord::Migration
  def self.up
    add_column :page_versions, :is_textile, :boolean, :default=>false
    
  end

  def self.down
    add_column :page_versions, :is_textile, :boolean, :default=>false
    
  end
end
