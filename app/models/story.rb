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
  accepts_nested_attributes_for :scenarios, :allow_destroy => true,
    :reject_if => :all_blank

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

  aasm :column => :status, :whiny_transitions => false do
    state :new, :initial => true, :after_enter => :set_transition_date
    state :in_progress, :after_enter => :set_transition_date
    state :quality_assurance, :after_enter => :set_transition_date
    state :completed, :after_enter => :set_completed_date
    event :assign do
      transitions :from => [:new, :in_progress, :quality_assurance, :completed], :to => :in_progress
    end

    event :check_quality do
      transitions :from => [:new, :in_progress, :quality_assurance, :completed], :to => :quality_assurance
    end

    event :finish do
      transitions :from => [:new, :in_progress, :quality_assurance, :completed], :to => :completed
    end

    event :back_to_new do
      transitions :from => [:new, :in_progress, :quality_assurance, :completed], :to => :new
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

  def set_transition_date
    self.transition_date = Date.today
  end

	def set_completed_date
		self.completed_date = Date.today
    self.transition_date = Date.today
	end

end
