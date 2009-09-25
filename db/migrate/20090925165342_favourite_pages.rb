class FavouritePages < ActiveRecord::Migration
  def self.up
    add_column :pages, :favorite, :boolean, :default=>false
  end

  def self.down
    remove_column :pages, :favorite
  end
end
