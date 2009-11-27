class CreateOutcomes < ActiveRecord::Migration
  def self.up
    create_table :outcomes do |t|
      t.string :description
      t.integer :scenario_id

      t.timestamps
    end
  end

  def self.down
    drop_table :outcomes
  end
end
