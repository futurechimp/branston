require 'test_helper'

class IterationTest < ActiveSupport::TestCase

  should_validate_presence_of :name

  should_have_many :stories
  should_have_many :geeks, :through => :participations

end

