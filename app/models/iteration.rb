class Iteration < ActiveRecord::Base

  # Validations
  #
  validates_presence_of :name, :velocity

  # Associations
  #
  has_many :stories
  has_many :participations
  has_many :geeks, :through => :participations, :class_name => "User"
end

