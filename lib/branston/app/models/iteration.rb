class Iteration < ActiveRecord::Base

  # Validations
  #
  validates_presence_of :name, :velocity

  # Associations
  #
  has_many :stories
  has_many :participations
  has_many :geeks, :through => :participations, :class_name => "User"
  belongs_to :release

  def burndown_data
    Story.find_by_sql [
      "SELECT SUM(points) AS points,
        completed_date
      FROM stories
      WHERE iteration_id = ?
      AND status = 'completed'
      GROUP BY completed_date
      ORDER bY completed_date", id
    ]
  end

end

