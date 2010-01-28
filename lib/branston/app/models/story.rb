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

include StoryGenerator

class Story < ActiveRecord::Base

  # Validations
  #
  validates_presence_of :description, :points, :title
  validates_uniqueness_of :title

  # Associations
  #
  belongs_to :iteration
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_many :scenarios, :dependent => :destroy
  has_one :user_role

  # Named scopes
  #
  named_scope :unassigned, :conditions => 'status = "new"'
  named_scope :in_progress, :conditions => 'status = "in_progress"'
  named_scope :completed, :conditions => 'status = "completed"'
  named_scope :for_iteration, lambda { |id| { :conditions => ['iteration_id = ?',
  id] } }

  before_save :set_slug

  # Story states
  # New - A story that has been drafted, but is not being worked on
  # In Progress - A story that is being actioned by a member of the development
  # team
  # Completed - A story that has been implemented and tested by the development
  # team
  #
  state_machine :status, :initial => :new do
    state :new
    state :in_progress
    state :completed

    event :assign do
      transition :new => :in_progress
    end

    event :finish do
      transition :in_progress => :completed
    end

    after_transition any => :completed do |story, transition|
      story.completed_date = Date.today
    end
  end
  
  attr_protected :status

  def to_param
    title.parameterize
  end

  private
  def set_slug
    self.slug = self.to_param
  end

end

