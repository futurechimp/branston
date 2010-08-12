require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase

  should validate_presence_of(:release_date)
  should have_many(:iterations)

end

