module Faker
  class Stories
    class << self
      def single_precondition
        r = Faker::Lorem.sentence
        out = ""
        r = r.split
        r[2] = '"' + r[2] + '"'
        r.collect { |s| out += s + " " }
        return out
      end
      
      def double_precondition
        r = Faker::Lorem.sentence.chop + " " + Faker::Lorem.sentence 
        out = ""
        r = r.split
        r[2] = '"' + r[2] + '"'
        r[5] = '"' + r[5] + '"'
        r.collect { |s| out += s + " " }
        return out
      end
    end
  end
end
