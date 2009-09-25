class ToolDescription < ActiveRecord::Migration
  def self.up
    add_column :tools, :description, :text
  end

  def self.down
    remove_column :tools, :description
  end
end
