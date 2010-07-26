require 'test_helper'

class IterationTest < ActiveSupport::TestCase

  should_validate_presence_of :name, :velocity
  should_validate_numericality_of :velocity

  should_have_many :stories
  should_have_many :geeks, :through => :participations
  should_have_many :participations
  should_belong_to :release

  context "An Iterations's burndown data method" do

    context "for incomplete stories" do

      setup do
        @iteration = Iteration.make
        Story.make(:points => 5, :iteration => @iteration)
        Story.make(:points => 2, :iteration => @iteration)
      end

      should "return an empty array" do
        assert_equal @iteration.burndown_data, []
      end
    end

    context "for completed stories" do
      setup do
        @iteration = Iteration.make
        Story.make(:points => 5, :iteration => @iteration, :status => "completed")
        Story.make(:points => 2, :iteration => @iteration, :status => "completed")
      end

      should "return a points value" do
        assert_match /7/, @iteration.burndown_data.to_s
      end
    end
  end

end

