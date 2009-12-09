require 'net/http'
require "rexml/document"
require 'ostruct'
require File.dirname(__FILE__) + '/../lib/story_generator'
include StoryGenerator

class Client
  
  attr_accessor :options, :errors
  
  def initialize(options)
    self.options = options
    self.errors = []
  end
  
  def generate_story_files
    begin 
      return process_xml get_xml
    rescue StandardError => e
      errors << "Could not connect to Branston server on " + 
        "#{options[:Host]}:#{options[:Port]}: #{e.message}\n" +
      "Is Branston running?"
    end
  end
  
  def process_xml(xml)
    errors.clear
    
    if xml.nil? or xml.root.nil? or xml.root.elements.nil?
      errors << "Did not recieve XML data for story #{options[:feature]}.\n" +
      "Is the Branston server running, and have you provided the correct story name?"
    else
      
      begin
        root = xml.root
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
      rescue StandardError => error
        errors << "Could not generate feature: " + error
      end
    end
  end
  
  def get_xml
    Net::HTTP.start(options[:Host] , options[:Port]) { |http|
      req = Net::HTTP::Get.new("/stories/#{options[:feature]}.xml")
      puts "generating /stories/#{options[:feature]}.xml"
      response = http.request(req)
      xml = REXML::Document.new response.body
      return xml
    }
  end
  
end

