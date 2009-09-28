class CreatePlanningApplications < ActiveRecord::Migration
  def self.up
    create_table :planning_applications do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :planning_applications
  end
end
