class AddNameToConstituencies < ActiveRecord::Migration
  def self.up
    add_column :constituencies, :name, :string
    add_column :wards, :name, :string
    add_column :wards, :constituency_id, :integer
  end

  def self.down
    
  end
end
