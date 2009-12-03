module StoryGenerator
  
  ALPHABET = ("a".."z").to_a unless defined?(ALPHABET)
  
  FEATURE_PATH='features/' unless defined?(FEATURE_PATH)
  FileUtils.mkdir FEATURE_PATH unless File.exists? FEATURE_PATH
  FileUtils.mkdir FEATURE_PATH + 'step_definitions' unless File.exists? FEATURE_PATH + 'step_definitions'

  def generate(story)
    @story = story
    make_steps(story)
    make_feature(story)
  end

  def feature_filename
    @story = self if @story.nil?
    clean_title(@story.title) + '.feature'
  end

  def step_filename
    @story = self if @story.nil?
    "step_definitions/" + clean_title(@story.title) + '_steps.rb'
  end

  private
  
  def clean_title(string)
    string.strip.gsub(' ', '_').gsub('"', '').downcase
  end
  
  def make_steps(story)
    steps = ""

    unless story.scenarios.empty?
      story.scenarios.each do |s|
        unless s.preconditions.empty?
          s.preconditions.each do |p|
            steps += "Given #{regexp(p.description)} do"
            vars = variables(p.description)
            unless vars.empty?
              steps += " |"
              for i in 0..variables(p.description).size-1
                steps += ALPHABET[i]
                steps += ", "
              end
              steps = steps.chop
              steps = steps.chop
              steps += "|"
            end
            steps += "\n"
            steps += "\t#TODO: Define these steps\n"
            steps += "\tpending\n"
            steps += "end\n\n"
          end
        end
        
        unless s.outcomes.empty?
          s.outcomes.each do |o|
            steps += "Then #{regexp(o.description)} do"
            vars = variables(o.description)
            unless vars.empty?
              steps += " |"
              for i in 0..variables(o.description).size-1
                steps += ALPHABET[i]
                steps += ", "
              end
              steps = steps.chop
              steps = steps.chop
              steps += "|"
            end
            steps += "\n"
            steps += "\t#TODO: Define these steps\n"
            steps += "\tpending\n"
            steps += "end\n\n"
          end
        end
      end
    end

    steps += "\n"
    File.open(FEATURE_PATH + step_filename, 'w') {|f| f.write(steps) }
  end

  def make_feature(story)
    gherkin = "Feature: #{story.title}\n"
    gherkin += "\tAs an actor\n"
    gherkin += "\t"
    gherkin += story.description
    gherkin += "\n\n"

    # Scenarios...
    unless story.scenarios.empty?
      story.scenarios.each do |scenario|
        gherkin += "\t@wip\n"
        gherkin += "\tScenario: "
        gherkin += scenario.title
        gherkin += "\n"

        unless scenario.preconditions.empty?
          scenario.preconditions.each_with_index do |p, i|
            gherkin += "\t\tGiven #{p.description}\n" if i == 0
            gherkin += "\t\t\tAnd #{p.description}\n" unless i == 0
          end
        end

        unless scenario.outcomes.empty?
          scenario.outcomes.each_with_index do |o, i|
            gherkin += "\t\tThen #{o.description}\n" if i==0
            gherkin += "\t\t\tAnd #{o.description}\n" unless i==0
          end
        end

        gherkin += "\n"
      end
    end

    File.open(FEATURE_PATH + feature_filename, 'w') {|f| f.write(gherkin) }
  end

  def regexp(string)
    pc = string.gsub(/"([^\"]*)"/, '"([^\"]*)"')
    "/^#{pc}$/"
  end

  def variables(string)
    variables = string.split(/"([^\"]*)"/)
    variables.each_with_index do |v, i|
      i % 2 == 0 ? variables[i] = nil : variables[i] = v
    end
    variables.compact
  end

end

