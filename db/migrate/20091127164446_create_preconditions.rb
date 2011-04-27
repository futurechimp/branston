class CreatePreconditions < ActiveRecord::Migration
  def self.up
    create_table :preconditions do |t|
      t.string :description
      t.integer :scenario_id

      t.timestamps
    end
  end

  def self.down
    drop_table :preconditions
  end
end
