require 'test_helper'

class ParticipationTest < ActiveSupport::TestCase

  should belong_to :user
  should belong_to :iteration

end

