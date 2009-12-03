class Scenario < ActiveRecord::Base

  # Assocations
  #
  belongs_to :story
  has_many :outcomes
  has_many :preconditions

  # Validations
  #
  validates_presence_of :title

end

