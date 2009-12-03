class Scenario < ActiveRecord::Base

  belongs_to :story
  has_many :outcomes
  has_many :preconditions

end

