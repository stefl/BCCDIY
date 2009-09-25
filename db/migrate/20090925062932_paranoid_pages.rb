class ParanoidPages < ActiveRecord::Migration
  def self.up
    add_column :pages, :deleted_at, :timestamp
  end

  def self.down
    remove_column :pages, :deleted_at, :timestamp
    
  end
end
