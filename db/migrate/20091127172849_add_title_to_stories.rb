class AddTitleToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :title, :string, :limit => 40
  end

  def self.down
    remove_column :stories, :title
  end
end
