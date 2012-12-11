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

class Scenario < ActiveRecord::Base

  # Assocations
  #
  belongs_to :story

  has_many :preconditions, :dependent => :destroy
  accepts_nested_attributes_for :preconditions, :allow_destroy => true,
    :reject_if => :all_blank

  has_many :outcomes, :dependent => :destroy
  accepts_nested_attributes_for :outcomes, :allow_destroy => true,
    :reject_if => :all_blank

  # Validations
  #
  validates_presence_of :title

end

