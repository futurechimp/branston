require 'machinist/active_record'
require 'sham'
require 'faker'

# Shams - generated filler values
#
Sham.define do
  name            { Faker::Lorem.words }
  description     { Faker::Lorem.sentences }
end



# Model class blueprints

Iteration.blueprint do
  velocity { 1 }
  name
end

Story.blueprint do
  description
  points { 2 }
end

