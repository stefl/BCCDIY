class RemoveParanoid < ActiveRecord::Migration
  def self.up
    remove_column :pages, :deleted_at
    
  end

  def self.down
    add_column :pages, :deleted_at, :timestamp
    
  end
end