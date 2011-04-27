class SetDefaultUserStateToPending < ActiveRecord::Migration
  def self.up
    change_column :users, :state, :string, :default => "pending"
  end

  def self.down
    change_column :users, :state, :string, :default => "passive"
  end
end

