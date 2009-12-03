require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  
  context "The Branston Client" do
    setup do
      @feature_file = FEATURE_PATH + 'product_search.feature'
      @step_file = FEATURE_PATH + '/step_definitions/product_search_steps.rb'
      mock_xml = REXML::Document.new File.new(RAILS_ROOT + "/test/xml/example.xml")
      REXML::Document.stubs(:new).returns(mock_xml)
      Client.new
    end
    
    should "generate a feature file that can be run by cucumber" do
      assert File.exists? @feature_file
      
      f = File.open(@feature_file, "r")
      begin
        assert_equal "Feature: Product Search\n", f.gets
        assert_equal "\tAs an actor\n", f.gets
        assert_equal "\tI should be able to search for products by title\n", f.gets
        f.gets # empty line
        assert_equal "\tScenario: I search for \"planes\"\n", f.gets
        assert_equal "\t\tGiven I search for \"planes\"\n", f.gets
        assert_equal "\t\t\tAnd \"planetoid\" is a fancy word for \"planet\"\n", f.gets
        assert_equal "\t\tThen A competition should appear\n", f.gets
        assert_equal "\n", f.gets
      ensure
        f.close
      end
    end
    
    should "generate a skeleton step definition file" do      
      assert File.exists? @step_file
      f = File.open(@step_file, "r")
      begin
        assert_equal "Given /^I search for \"([^\\\"]*)\"$/ do |a|\n", f.gets
        assert_equal "\t#TODO: Define these steps\n", f.gets
        assert_equal "end\n", f.gets
        assert_equal "\n", f.gets
        
        assert_equal "Given /^\"([^\\\"]*)\" is a fancy word for \"([^\\\"]*)\"$/ do |a, b|\n", f.gets
        assert_equal "\t#TODO: Define these steps\n", f.gets
        assert_equal "end\n", f.gets
        assert_equal "\n", f.gets
        
        assert_equal "\n", f.gets
      ensure
        f.close
      end
    end
    
    
  end
  
end

