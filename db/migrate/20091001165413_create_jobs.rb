class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      
      t.timestamps
    end
    
    add_column :users, :postcode, :string
  end

  def self.down
    drop_table :jobs
    remove_column :users, :postcode
  end
end
