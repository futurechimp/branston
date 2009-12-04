require 'net/http'
require "rexml/document"
require 'ostruct'
require File.dirname(__FILE__) + '/../lib/story_generator'
include StoryGenerator

class Client
  
  attr_accessor :options
  
  def initialize(options)
    self.options = options
  end
  
  def generate_story_files
    
    @xml = get_xml
    #puts @xml
    unless @xml.nil?
      root = @xml.root
      story = OpenStruct.new
      story.description = root.elements["/story/description"].text
      story.title = root.elements["/story/title"].text
      story.scenarios = []
      root.elements.each("/story/scenarios/scenario") { |scenario|
        s = OpenStruct.new
        s.preconditions = []
        s.outcomes = []
        s.title = scenario.elements["title"].text
        
        scenario.elements.each("preconditions/precondition") { |precondition|
          p = OpenStruct.new
          p.description = precondition.elements["description"].text
          s.preconditions << p
        }
        
        scenario.elements.each("outcomes/outcome") { |outcome|          
          o = OpenStruct.new
          o.description = outcome.elements["description"].text
          s.outcomes << o
        }
        
        story.scenarios << s
      }
      
      generate(story)
    end
  end
   
  def get_xml
    Net::HTTP.start(options[:Host] , options[:Port]) { |http|
      req = Net::HTTP::Get.new("/stories/#{options[:feature_id]}.xml")
      response = http.request(req)
      xml = REXML::Document.new response.body
      return xml
    }
  end
  
end

