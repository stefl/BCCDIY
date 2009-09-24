class AddUserToRevisions < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter, :string
    add_column :page_versions, :user_id, :integer, :default=>1
  end

  def self.down
    remove_column :users, :twitter
    remove_column :page_versions, :user_id
  end
end
