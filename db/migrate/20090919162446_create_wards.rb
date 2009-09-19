class CreateWards < ActiveRecord::Migration
  def self.up
    create_table :wards do |t|
      t.name :string
      t.constituency_id :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :wards
  end
end
