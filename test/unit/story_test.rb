require 'test_helper'

class StoryTest < ActiveSupport::TestCase

  should_validate_presence_of :description, :points
  should_have_many :scenarios
  should_have_one :user_role
  should_belong_to :iteration
  should_belong_to :author

  context "a Story" do
    setup do
      @story = Factory.make_story(:title => "Product Search", 
        :description => "I should be able to search for products by title")
      @feature_file = FEATURE_PATH + @story.feature_filename
      @step_file = FEATURE_PATH + @story.step_filename
    end

    teardown do      
      FileUtils.rm @feature_file if File.exists? @feature_file
      FileUtils.rm @step_file if File.exists? @step_file
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
      @story.make_feature
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
      @story.make_steps
      assert File.exists? @step_file
      f = File.open(@step_file, "r")
      begin
        pc = @story.scenarios.first.preconditions[0]
        assert_equal "Given #{pc.regexp.to_s} do |a|\n", f.gets
        assert_equal "\t#TODO: Define these steps\n", f.gets
        assert_equal "end\n", f.gets
        assert_equal "\n", f.gets
        
        pc = @story.scenarios.first.preconditions[1]
        assert_equal "Given #{pc.regexp.to_s} do |a, b|\n", f.gets
        assert_equal "\t#TODO: Define these steps\n", f.gets
        assert_equal "end\n", f.gets
        assert_equal "\n", f.gets
        
        pc = @story.scenarios.last.preconditions[0]
        assert_equal "Given #{pc.regexp.to_s} do |a|\n", f.gets
        assert_equal "\t#TODO: Define these steps\n", f.gets
        assert_equal "end\n", f.gets
        assert_equal "\n", f.gets
        
        pc = @story.scenarios.last.preconditions[1]
        assert_equal "Given #{pc.regexp.to_s} do |a, b|\n", f.gets
        assert_equal "\t#TODO: Define these steps\n", f.gets
        assert_equal "end\n", f.gets
        assert_equal "\n", f.gets
        
        assert_equal "\n", f.gets
      ensure
        f.close
      end
    end

  end

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

