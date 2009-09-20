class PermalinkWards < ActiveRecord::Migration
  def self.up
    add_column :wards, :permalink, :string
    add_column :constituencies, :permalink, :string
    
  end

  def self.down
    remove_column :wards, :permalink
    remove_column :constituencies, :permalink
  end
end
