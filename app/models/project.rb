class Project < ActiveRecord::Base
  has_many :iterations
  has_many :participations
  has_many :participants, :through => :participations, :source => :user

  validates_presence_of :name
  validates_uniqueness_of :name

  # scopes
  #
  named_scope :alphabetical, :order => "name ASC"

  def self.permit?(role, action)
    case action
      when :create
        return (role == 'admin' or role == 'developer' ? true : false)
      when :update
        return (role == 'admin' or role == 'developer' ? true : false)
      when :destroy
        return (role == 'admin' ? true : false)
    end
  end

end
