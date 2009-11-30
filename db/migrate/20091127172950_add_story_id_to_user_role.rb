class AddStoryIdToUserRole < ActiveRecord::Migration
  def self.up
    add_column :user_roles, :story_id, :integer, :nil => false
  end

  def self.down
    remove_column :user_roles, :story_id
  end
end

