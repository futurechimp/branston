class AddTransitionDateToStories < ActiveRecord::Migration
  def self.up
    add_column :stories, :transition_date, :date
  end
  
  def self.down
    remove_column :stories, :transition_date
  end
end
