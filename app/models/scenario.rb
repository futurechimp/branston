class Scenario < ActiveRecord::Base

  belongs_to :story
  has_many :outcomes
  has_many :preconditions

  named_scope :by_story, lambda { |story| { :conditions => ["story_id = ?", story.id] }}

end

