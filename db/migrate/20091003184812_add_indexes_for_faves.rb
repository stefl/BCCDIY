class AddIndexesForFaves < ActiveRecord::Migration
  def self.up
    add_index :pages, :favorite
  end

  def self.down
    remove_index :pages, :favorite
    
  end
end
