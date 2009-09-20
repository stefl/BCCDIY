class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
