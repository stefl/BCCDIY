class AddDirectorate < ActiveRecord::Migration
  def self.up
    add_column :jobs, :directorate, :string
  end

  def self.down
    remove_column :jobs, :directorate
  end
end
