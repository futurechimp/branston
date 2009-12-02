class Precondition < ActiveRecord::Base

  belongs_to :scenario

  def to_s
    read_attribute(:description)
  end
  
end

