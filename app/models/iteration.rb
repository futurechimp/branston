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
  validates_numericality_of :velocity
  validates_numericality_of :project_id

  # Associations
  #
  has_many :stories
  belongs_to :release
  belongs_to :project

  def burndown_data(status="completed")
    Story.find_by_sql [
      "SELECT SUM(points) AS points,
        transition_date
      FROM stories
      WHERE iteration_id = ?
      AND status = ?
      GROUP BY transition_date
      ORDER BY transition_date", id, status
    ]
  end

  def start_date=(date)
    if date.is_a?(String)
      @start_date = Date.strptime(date, "%d/%m/%Y")
    else
      @start_date = date
    end
  end

end
