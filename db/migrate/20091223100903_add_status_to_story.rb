class AddStatusToStory < ActiveRecord::Migration
  def self.up
    add_column :stories, :status, :string, :limit => 50
    add_column :stories, :completed_date, :date
  end

  def self.down
    remove_column :stories, :status
    remove_column :stories, :completed_date
  end
end
