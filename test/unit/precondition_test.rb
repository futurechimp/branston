require 'test_helper'

class PreconditionTest < ActiveSupport::TestCase

  should validate_presence_of :description
  should belong_to :scenario

end

