class CreateReleases < ActiveRecord::Migration
  def self.up
    create_table :releases do |t|
      t.date :release_date
      t.text :notes

      t.timestamps
    end
    
    add_column :iterations, :release_id, :integer
  end

  def self.down
    drop_table :releases
    remove_column :iterations, :release_id
  end
end
