include StoryGenerator

class Story < ActiveRecord::Base

  # Validations
  #
  validates_presence_of :description, :points, :title
  validates_uniqueness_of :title

  # Associations
  #
  belongs_to :iteration
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  has_many :scenarios, :dependent => :destroy
  has_one :user_role

  # Named scopes
  #
  named_scope :in_progress, :conditions => ['iteration_id IS NOT ?', nil]
  
  before_save :set_slug
  
  def to_param
    title.parameterize
  end
  
  private
  def set_slug
    self.slug = self.to_param
  end
    
end

