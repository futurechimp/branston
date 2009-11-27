class Story < ActiveRecord::Base

  # Validations
  #
  validates_presence_of :description, :points

  # Associations
  #
  belongs_to :iteration

  # Named scopes
  #
  named_scope :in_progress, :conditions => ['iteration_id IS NOT ?', nil]

end

