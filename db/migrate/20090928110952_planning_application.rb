class PlanningApplication < ActiveRecord::Migration
  def self.up
    drop_table :planning_applications
    
    create_table :planning_applications do |t|

      t.timestamps
    end
    
    add_column :planning_applications, :council_reference, :string
    add_column :planning_applications, :council_id, :string
    add_column :planning_applications, :address, :string
    add_column :planning_applications, :postcode, :string
    add_column :planning_applications, :description, :text
    add_column :planning_applications, :info_url, :string
    add_column :planning_applications, :comment_url, :string
    add_column :planning_applications, :date_received, :timestamp
    add_column :planning_applications, :ward_id, :integer
    
  end

  def self.down
  end
end
