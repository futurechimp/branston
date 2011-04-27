class SetDefaultUserStateToActive < ActiveRecord::Migration
  def self.up
    change_column :users, :state, :string, :default => "active"
  end

  def self.down
    change_column :users, :state, :string, :default => "pending"
  end
end

