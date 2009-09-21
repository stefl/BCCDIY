class RedoOpenly < ActiveRecord::Migration
  def self.up
    add_column :wards, :openly_local_ward_id, :integer
    add_column :constituencies, :openly_local_constituency_id, :integer
    add_column :members, :openly_local_member_id, :integer
    add_column :committees, :openly_local_committee_id, :integer
  end

  def self.down
  end
end
