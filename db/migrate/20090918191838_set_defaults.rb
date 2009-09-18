class SetDefaults < ActiveRecord::Migration
  def self.up
    change_column :pages, :alias, :boolean, :default=>false
  end

  def self.down
    change_column :pages, :alias, :boolean
  end
end
