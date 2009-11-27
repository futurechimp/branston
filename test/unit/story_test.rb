require 'test_helper'

class StoryTest < ActiveSupport::TestCase

  should_validate_presence_of :description, :points

  should_belong_to :iteration
  should_belong_to :author

  context "The Story class" do

    should "have an in_progress named_scope" do
      assert Story.respond_to?("in_progress")
    end


    context "named_scope in_progress" do
      setup do
        Story.make
        Story.make(:in_progress)
      end

      should "only find stories that are assigned to an iteration" do
        assert_equal 1, Story.in_progress.count
      end
    end

  end

end

