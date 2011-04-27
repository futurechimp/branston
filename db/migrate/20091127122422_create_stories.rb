class CreateStories < ActiveRecord::Migration
  def self.up
    create_table :stories do |t|
      t.text :description
      t.integer :points
      t.integer :iteration_id

      t.timestamps
    end
  end

  def self.down
    drop_table :stories
  end
end

