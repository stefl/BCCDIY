class CreateRestyles < ActiveRecord::Migration
  def self.up
    create_table :restyles do |t|
      t.string :title
      t.string :description
      t.text :css
      t.integer :times_used, :default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :restyles
  end
end
