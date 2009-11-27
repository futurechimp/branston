require 'test_helper'

class ScenarioTest < ActiveSupport::TestCase

  should_belong_to :story

  should_have_many :preconditions
  should_have_many :outcomes

end

