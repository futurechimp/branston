require 'test_helper'

class OutcomeTest < ActiveSupport::TestCase

  should belong_to :scenario
  should validate_presence_of :description

end

