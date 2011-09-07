class ChangeTitleColumnLength < ActiveRecord::Migration
  def self.up
		change_column :stories, :title, :string, :limit => 255
  end

  def self.down
		change_column :stories, :title, :string, :limit => 40
  end
end
