require 'test_helper'

class PreconditionTest < ActiveSupport::TestCase

  should_validate_presence_of :description

  should_belong_to :scenario
  
end
