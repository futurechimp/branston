#    This file is part of Branston.
#
#    Branston is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as published by
#    the Free Software Foundation.
#
#    Branston is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.
#
#    You should have received a copy of the GNU Affero General Public License
#    along with Branston.  If not, see <http://www.gnu.org/licenses/>.



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
    Iteration.find_by_sql [
      "SELECT SUM(points) AS total_points,
        COUNT(points) AS points,
        completed_date
      FROM stories
      WHERE iteration_id = ?
      AND status = 'completed'
      GROUP BY completed_date", id
    ]
  end

end

