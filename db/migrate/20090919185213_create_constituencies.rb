class CreateConstituencies < ActiveRecord::Migration
  def self.up
    create_table :constituencies do |t|
      t.name :string
      t.timestamps
    end
  end

  def self.down
    drop_table :constituencies
  end
end
