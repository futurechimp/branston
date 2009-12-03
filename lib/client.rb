require 'net/http'
require "rexml/document"
require 'ostruct'
require 'lib/story_generator'
include StoryGenerator

class Client
  
  attr_accessor :args
  
  def initialize(*args)
   # puts args
    self.args = args
    generate_story_files
  end
  
  def generate_story_files

    Net::HTTP.start(args[1] , args[2]) {|http|
      req = Net::HTTP::Get.new(args[3])
      response = http.request(req)
      xml = REXML::Document.new response.body
      #puts xml
      root = xml.root
      story = OpenStruct.new
      story.description = root.elements["/story/description"].text
      story.title = root.elements["/story/title"].text
      story.scenarios = []
      root.elements.each("/story/scenarios") { |scenario|
        s = OpenStruct.new
        s.preconditions = []
        s.outcomes = []
        s.title = scenario.elements["scenario/title"].text
        
        scenario.elements.each("scenario/preconditions/precondition") { |precondition|
          p = OpenStruct.new
          p.description = precondition.elements["description"].text
          s.preconditions << p
        }
        
        scenario.elements.each("scenario/outcomes/outcome") { |outcome|
          o = OpenStruct.new
          o.description = outcome.elements["description"].text
          s.outcomes << o
        }
        
        story.scenarios << s
      }
      
      generate(story)
    }
  end

end

