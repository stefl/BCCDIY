class CreateJobs < ActiveRecord::Migration
  def self.up
    create_table :jobs do |t|
      t.string :title
      t.text    :service_area
      t.integer :salary_low
      t.integer :salary_high
      t.string :salary
      t.string :reference
      t.string :contract_type
      t.date   :closing_date
      t.boolean :cbi_check
      t.string :cbi_check_text
      t.text   :description
      
      
      t.timestamps
    end
    
    add_column :users, :postcode, :string
  end

  def self.down
    drop_table :jobs
    remove_column :users, :postcode
  end
end
