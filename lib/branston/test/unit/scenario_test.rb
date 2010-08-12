require 'test_helper'

class ScenarioTest < ActiveSupport::TestCase

  should validate_presence_of :title

  should belong_to :story
  should have_many :preconditions
  should have_many :outcomes

end

