class ChangeParticipationSoItBelongsToProject < ActiveRecord::Migration
  def self.up
    Participation.destroy_all
    rename_column :participations, :iteration_id, :project_id
  end

  def self.down
    rename_column :participations, :project_id, :iteration_id
  end
end
