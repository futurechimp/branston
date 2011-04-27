class CreateParticipations < ActiveRecord::Migration
  def self.up
    create_table :participations do |t|
      t.integer :user_id
      t.integer :iteration_id

      t.timestamps
    end
  end

  def self.down
    drop_table :participations
  end
end

