class AddProjectToRelease < ActiveRecord::Migration
  def self.up
    add_column :releases, :project_id, :integer
  end
  
  def self.down
    remove_column :releases, :project_id
  end
end
