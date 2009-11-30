require 'test_helper'

class ParticipationTest < ActiveSupport::TestCase

  should_belong_to :user
  should_belong_to :iteration

end

