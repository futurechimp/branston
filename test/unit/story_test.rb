require 'test_helper'
include StoryGenerator

class StoryTest < ActiveSupport::TestCase

  should validate_presence_of :description
  should validate_presence_of :points
  should have_many :scenarios
  should belong_to :iteration
  should belong_to :author

  context "a Story" do
    setup do
      @story = Factory.make_story(:title => "Product Search",
        :description => "I should be able to search for products by title")
      @feature_file = FEATURE_PATH + @story.feature_filename
      @step_file = FEATURE_PATH + @story.step_filename
    end

    teardown do
      FileUtils.rm @feature_file if @feature_file != nil and File.exists? @feature_file
      FileUtils.rm @step_file if @step_file != nil and File.exists? @step_file
    end

    should "start life with status new" do
      assert @story.new?
    end

    context "attempting to transition from :new to :finish" do
      setup do
        @story.finish        
      end

      should "get the story in a :finished state" do
        assert @story.completed?
      end
    end

    context "attempting to transition from :new to :check_quality" do
      setup do
        @story.check_quality
      end
      should "get the story into quality_assurance state" do
        assert @story.quality_assurance?
      end
    end

    context "transisted to in_progress" do
      setup do
        assert @story.assign
      end

      should "transist to in_progress" do
        assert @story.in_progress?
      end

      context "then transitioned to completed" do
        setup do
          assert @story.finish
        end

        should "transist to completed" do
          assert @story.completed?
        end

        should "set the completed date when in the completed state" do
          assert_equal Date.today, @story.completed_date
        end
      end
    end

    should "set a slug when its saved" do
      assert_not_nil @story.slug
      assert_equal 'product-search', @story.slug

      @story.title = "updated title"
      assert @story.save
      assert_equal 'updated-title', @story.slug
    end

		should "match to_param and slug when the title is long" do
			@story.title = "this is a really really really really long title"
      assert @story.save
      assert_equal @story.to_param, @story.slug
		end

    should "have a unique title" do
      assert_no_difference 'Story.count' do
        assert_raise ActiveRecord::RecordInvalid do
          u = Story.make(:title => @story.title)
          assert u.errors.on(:title)
        end
      end
    end

    should "know by convention what its filename ought to be" do
      assert_equal "product_search.feature", @story.feature_filename
    end

    should "generate a feature file that can be run by cucumber" do
      @story.generate(@story)
      assert File.exists? @feature_file

      f = File.open(@feature_file, "r")
      begin
        assert_equal "Feature: Product Search\n", f.gets
        assert_equal "\tAs an actor\n", f.gets
        assert_equal "\tI should be able to search for products by title\n", f.gets
        f.gets # empty line
        assert_equal "\tScenario: #{@story.scenarios.first.title}\n", f.gets
        assert_equal "\t\tGiven #{@story.scenarios.first.preconditions.first}\n", f.gets
        assert_equal "\t\t\tAnd #{@story.scenarios.first.preconditions.last}\n", f.gets
        assert_equal "\t\tThen #{@story.scenarios.first.outcomes.first}\n", f.gets
        assert_equal "\t\t\tAnd #{@story.scenarios.first.outcomes.last}\n", f.gets
        assert_equal "\n", f.gets
      ensure
        f.close
      end
    end

    should "generate a skeleton step definition file" do
      @story.generate(@story)
      assert File.exists? @step_file
      f = File.open(@step_file, "r")
      begin
        pc = @story.scenarios.first.preconditions[0]
        assert_equal "Given #{regexp(pc.to_s)} do |a|\n", f.gets
        assert_equal "\t#TODO: Define these steps\n", f.gets
        assert_equal "\tpending\n", f.gets
        assert_equal "end\n", f.gets
        assert_equal "\n", f.gets

        pc = @story.scenarios.first.preconditions[1]
        assert_equal "Given #{regexp(pc.to_s)} do |a, b|\n", f.gets
        assert_equal "\t#TODO: Define these steps\n", f.gets
        assert_equal "\tpending\n", f.gets
        assert_equal "end\n", f.gets
        assert_equal "\n", f.gets

        outcome = @story.scenarios.first.outcomes[0]
        assert_equal "Then #{regexp(outcome.to_s)} do |a|\n", f.gets
        assert_equal "\t#TODO: Define these steps\n", f.gets
        assert_equal "\tpending\n", f.gets
        assert_equal "end\n", f.gets
        assert_equal "\n", f.gets

        outcome = @story.scenarios.first.outcomes[1]
        assert_equal "Then #{regexp(outcome.to_s)} do |a|\n", f.gets
        assert_equal "\t#TODO: Define these steps\n", f.gets
        assert_equal "\tpending\n", f.gets
        assert_equal "end\n", f.gets
        assert_equal "\n", f.gets

        pc = @story.scenarios.last.preconditions[0]
        assert_equal "Given #{regexp(pc.to_s)} do |a|\n", f.gets
        assert_equal "\t#TODO: Define these steps\n", f.gets
        assert_equal "\tpending\n", f.gets
        assert_equal "end\n", f.gets
        assert_equal "\n", f.gets

        pc = @story.scenarios.last.preconditions[1]
        assert_equal "Given #{regexp(pc.to_s)} do |a, b|\n", f.gets
        assert_equal "\t#TODO: Define these steps\n", f.gets
        assert_equal "\tpending\n", f.gets
        assert_equal "end\n", f.gets
        assert_equal "\n", f.gets

        outcome = @story.scenarios.last.outcomes[0]
        assert_equal "Then #{regexp(outcome.to_s)} do |a|\n", f.gets
        assert_equal "\t#TODO: Define these steps\n", f.gets
        assert_equal "\tpending\n", f.gets
        assert_equal "end\n", f.gets
        assert_equal "\n", f.gets

        outcome = @story.scenarios.last.outcomes[1]
        assert_equal "Then #{regexp(outcome.to_s)} do |a|\n", f.gets
        assert_equal "\t#TODO: Define these steps\n", f.gets
        assert_equal "\tpending\n", f.gets
        assert_equal "end\n", f.gets
        assert_equal "\n", f.gets

        assert_equal "\n", f.gets
      ensure
        f.close
      end
    end

  end

  context "The Story class" do

    should "have an in_progress named_scope" do
      assert Story.respond_to?("in_progress")
    end

    context "named_scope in_progress" do
      setup do
        @story = Story.make
        @in_progress = Story.make(:in_progress)
        @completed = Story.make(:completed)
        @iteration = @story.iteration
      end

      should "only find stories that are assigned to an iteration" do
        assert_equal @story, Story.for_iteration(@iteration.id).first
      end

      should "only find stories that are unassigned" do
        assert_equal @story, Story.unassigned.first
      end

      should "only find stories that are in progress" do
        assert_equal @in_progress, Story.in_progress.first
      end

      should "only find stories that are completed" do
        assert_equal @completed, Story.completed.first
      end
    end

  end

end

