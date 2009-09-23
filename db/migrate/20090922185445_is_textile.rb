class IsTextile < ActiveRecord::Migration
  def self.up
    add_column :pages, :is_textile, :boolean, :default=>false
  end

  def self.down
    remove_column :pages, :is_textile
    
  end
end
