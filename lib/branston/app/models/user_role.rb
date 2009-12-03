class UserRole < ActiveRecord::Base

  validates_presence_of :name
  belongs_to :story

end

