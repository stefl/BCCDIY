class FavouritePages < ActiveRecord::Migration
  def self.up
    change_column :pages, :favorite, :boolean, :default=>false, :null=>false
  end

  def self.down
  end
end
