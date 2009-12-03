class Scenario < ActiveRecord::Base

  # Assocations
  #
  belongs_to :story
  has_many :outcomes
  has_many :preconditions

  # Validations
  #
  validates_presence_of :title

  # Macros
  #
  named_scope :by_story, lambda { |story| { :conditions => ["story_id = ?", story.id] }}

end

