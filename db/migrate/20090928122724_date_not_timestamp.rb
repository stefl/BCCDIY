class DateNotTimestamp < ActiveRecord::Migration
  def self.up
    change_column :planning_applications, :date_received, :date
  end

  def self.down
    change_column :planning_applications, :date_received, :timestamp
  end
end
