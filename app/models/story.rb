class Story < ActiveRecord::Base

  # Validations
  #
  validates_presence_of :description, :points, :title
  validates_uniqueness_of :title
  
  # Associations
  #
  belongs_to :iteration
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"

  # Named scopes
  #
  named_scope :in_progress, :conditions => ['iteration_id IS NOT ?', nil]
  
  def feature_filename
    title.parameterize('_').to_s + '.feature'
  end
  
  def make_feature
    gherkin = "Feature: #{title}\n"
    File.open(FEATURE_PATH + feature_filename, 'w') {|f| f.write(gherkin) }
  end
end

