class PageIndexes < ActiveRecord::Migration
  def self.up
    add_index :pages, :title
  end

  def self.down
    remove_index :pages, :title
  end
end
