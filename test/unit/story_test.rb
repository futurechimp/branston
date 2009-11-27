require 'test_helper'

class StoryTest < ActiveSupport::TestCase

  should_validate_presence_of :description, :points
  
  context "a Story" do    
    setup do
      @story = Story.make(:description => "purchase some products")
    end
    
    should "have a unique description" do
      assert_no_difference 'Story.count' do
        assert_raise ActiveRecord::RecordInvalid do
          u = Story.make(:description => @story.description)          
          assert u.errors.on(:description)
        end
      end
    end
    
    should "know by convention what its filename ought to be" do
      assert_equal "purchase_some_products.feature", @story.feature_filename
    end
    
    should "generate a feature file that can be run by cucumber" do
      @story.make_feature
      assert File.exists? 'test/features/' + @story.feature_filename
      
    end
    
  end

end

