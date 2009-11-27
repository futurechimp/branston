require 'test_helper'

class StoryTest < ActiveSupport::TestCase

  should_validate_presence_of :description, :points
  should_have_many :scenarios

  context "a Story" do
    setup do
      @story = Story.make_unsaved(:title => "Product Search", :description => "I should" +
        " be able to search for products by title")
      @story.scenarios.make(:title => "Try searching for 'Dizzy Rascal'")
      @story.save!
    end

    teardown do
      feature_file = 'test/features/' + @story.feature_filename
      FileUtils.rm feature_file if File.exists? feature_file
      Story.delete_all
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
      feature_file = 'test/features/' + @story.feature_filename
      assert File.exists? feature_file
      f = File.open(feature_file, "r")
      begin
        assert_equal "Feature: Product Search\n", f.gets
        assert_equal "\tAs an actor\n", f.gets
        assert_equal "\tI should be able to search for products by title\n", f.gets
        #empty line
        f.gets
        assert_equal "\tScenario: Try searching for 'Dizzy Rascal'\n", f.gets
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

