require 'test_helper'
include StoryGenerator

class StoryGeneratorTest < ActiveSupport::TestCase
  
  context "The Story Generator" do
    setup do
      d = 'A product called "onion chutney"'
      @pc = Precondition.make(:description => d)
    end
    
    context "regexp method" do
      should "replace any quoted string with a regular expression" do
        assert_equal "/^A product called \"([^\\\"]*)\"$/", regexp('A product called "onion chutney"')
      end
    end
    
    context "variables method" do
      
      setup do
        @string = Precondition.make.description
        @longer_string = Precondition.make(:longer).description
      end
      
      should "build an array of variables" do
        assert_equal ['onion chutney'], variables("And a product \"onion chutney\"")
      end
      
      should "know how many variables it has in quotes" do
        assert_equal 1, variables(@string).size
        assert_equal 2, variables(@longer_string).size
      end
    end
  end
  
end

