class CreateIterations < ActiveRecord::Migration
  def self.up
    create_table :iterations do |t|
      t.integer :velocity
      t.string :name
      t.datetim :start_date
      t.datetime :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :iterations
  end
end
