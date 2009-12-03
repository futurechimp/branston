class Precondition < ActiveRecord::Base

  belongs_to :scenario

  def to_s
    read_attribute(:description)
  end
  
  def regexp
    pc = self.to_s.gsub(/"([^\"]*)"/, '"([^\"]*)"')
    "/^#{pc}$/"
  end
  
  def variables
    variables = self.to_s.split(/"([^\"]*)"/)    
    variables.each_with_index do |v, i|
      i % 2 == 0 ? variables[i] = nil : variables[i] = v
    end
    variables.compact
  end
  
end

