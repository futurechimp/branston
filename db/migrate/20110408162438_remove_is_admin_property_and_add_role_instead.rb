class RemoveIsAdminPropertyAndAddRoleInstead < ActiveRecord::Migration
  def self.up
    remove_column :users, :is_admin
    add_column :users, :role, :string
  end

  def self.down
    add_column :users, :is_admin, :boolean, :default => false
    remove_column :users, :role
  end
end

