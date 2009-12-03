require 'test_helper'

class PreconditionTest < ActiveSupport::TestCase

  should_validate_presence_of :description

  should_belong_to :scenario

  context "a precondition with one variable" do
    setup do
      d = 'A product called "onion chutney"'
      @pc = Precondition.make(:description => d)
    end

    should "replace any quoted string with a regular expression" do
      assert_equal "/^A product called \"([^\\\"]*)\"$/", @pc.regexp
    end

    should "build an array of variables" do
      assert_equal ['onion chutney'], @pc.variables
    end

    should "know how many variables it has in quotes" do
      assert_equal 1, @pc.variables.size
      assert_equal 2, Precondition.make(:longer).variables.size
    end
  end

end

