class Story < ActiveRecord::Base

  validates_presence_of :description, :points
  validates_uniqueness_of :description
  
  def feature_filename
    description.parameterize('_').to_s + '.feature'
  end
  
  def make_feature
    gherkin = "Feature: #{description}\n"
    File.open(FEATURE_PATH + feature_filename, 'w') {|f| f.write(gherkin) }
  end
    
  
end

