class Scenario < ActiveRecord::Base

  # Assocations
  #
  belongs_to :story
  has_many :outcomes, :dependent => :destroy
  has_many :preconditions, :dependent => :destroy

  # Validations
  #
  validates_presence_of :title

end

