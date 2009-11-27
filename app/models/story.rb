class Story < ActiveRecord::Base

  validates_presence_of :description, :points, :title
  validates_uniqueness_of :title
  
  def feature_filename
    title.parameterize('_').to_s + '.feature'
  end
  
  def make_feature
    gherkin = "Feature: #{title}\n"
    File.open(FEATURE_PATH + feature_filename, 'w') {|f| f.write(gherkin) }
  end
    
  
end

