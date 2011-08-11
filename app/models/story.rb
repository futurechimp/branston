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
  validates_presence_of :title, :description, :points 
  validates_uniqueness_of :title

  # Associations
  #
  belongs_to :iteration
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_many :scenarios, :dependent => :destroy

  # Named scopes
  #
  named_scope :unassigned, :conditions => "status = 'new'"
  named_scope :in_progress, :conditions => "status = 'in_progress'"
  named_scope :in_quality_assurance, :conditions => "status = 'quality_assurance'"
  named_scope :completed, :conditions => "status = 'completed'"
  named_scope :for_iteration, lambda { |id| {
    :conditions => ['iteration_id = ?', id] } }

  before_save :set_slug

  # Story states
  #
  # New - A story that has been drafted, but is not being worked on
  #
  # In Progress - A story that is being actioned by a member of the development
  # team
  #
  # Quality Assurance - A story that is being tested by the QA department
  #
  # Completed - A story that has been implemented and tested by the development
  # team
  #
  include AASM
  aasm_column :status
  aasm_initial_state :new
  aasm_state :new, :enter => :set_transition_date
  aasm_state :in_progress
  aasm_state :quality_assurance, :enter => :set_transition_date
  aasm_state :completed, :enter => Proc.new  { |story, transition|
                               story.completed_date = Date.today
                               story.transition_date = Date.today
                             }

  aasm_event :assign do
    transitions :from => [:new, :quality_assurance, :completed], :to => :in_progress
  end

  aasm_event :check_quality do
    transitions :from => [:in_progress, :quality_assurance, :completed], :to => :quality_assurance
  end

  aasm_event :finish do
    transitions :from => [:in_progress, :quality_assurance], :to => :completed
  end

  aasm_event :back_to_new do
    transitions :from => [:new, :in_progress], :to => :new
  end

  attr_protected :status

  def to_param
    title.parameterize
  end

  private

  def set_slug
    self.slug = self.to_param
  end

  def set_transition_date
    transition_date = Date.today
  end

end
