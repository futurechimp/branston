class AddStatusToStory < ActiveRecord::Migration
  def self.up
    add_column :stories, :status, :string, :limit => 10
  end

  def self.down
    remove_column :stories, :status
  end
end
