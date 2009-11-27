class Story < ActiveRecord::Base

  # Validations
  #
  validates_presence_of :description, :points

  # Associations
  #
  belongs_to :iteration

end

