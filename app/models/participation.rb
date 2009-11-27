class Participation < ActiveRecord::Base

  belongs_to :user
  belongs_to :iteration

end

