class AddSlugs < ActiveRecord::Migration
  def self.up
    add_column :pages, :slug, :string
  end

  def self.down
    remove_column :pages, :slug
  end
end
