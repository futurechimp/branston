class Release < ActiveRecord::Base
  
  validates_presence_of :release_date
  
  has_many :iterations, :order => 'end_date'
  
end
