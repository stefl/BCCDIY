class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :url
      t.text :page_source
      t.string :title
      t.string :keywords
      t.string :description
      t.string :categories
      t.text :breadcrumb
      t.text :content
      t.string :parent_url
      t.integer :parent_id
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
