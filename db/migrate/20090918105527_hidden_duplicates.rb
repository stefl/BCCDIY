class HiddenDuplicates < ActiveRecord::Migration
  def self.up
    add_column :pages, :alias_id, :integer
    add_column :pages, :alias, :boolean
  end

  def self.down
    remove_column :pages, :alias_id
    remove_column :pagesm, :alias
  end
end
