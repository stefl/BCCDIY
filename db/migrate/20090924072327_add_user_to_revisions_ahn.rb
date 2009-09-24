class AddUserToRevisionsAhn < ActiveRecord::Migration
  def self.up
    add_column :pages, :user_id, :integer, :default=>1
  end

  def self.down
    remove_column :page_versions, :user_id
    
  end
end
