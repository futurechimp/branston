require 'test_helper'

class OutcomeTest < ActiveSupport::TestCase

  should_belong_to :scenario
  should_validate_presence_of :description

end

