class Outcome < ActiveRecord::Base

  # Assocations
  #
  belongs_to :scenario

  # Validations
  #
  validates_presence_of :description

  def to_s
    read_attribute(:description)
  end

end

