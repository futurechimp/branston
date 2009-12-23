require 'machinist/active_record'
require 'sham'
require 'faker'
require 'faker_extras'

# Shams - generated filler values
#
Sham.define do
  name               { Faker::Lorem.words }
  title              { Faker::Lorem.sentence }
  description        { Faker::Stories.single_precondition }
  long_description   { Faker::Stories.double_precondition }
  notes              { Faker::Lorem.sentences }
  email              { Faker::Internet.email }
  login              { Faker::Name.first_name }
end

# Model class blueprints

Iteration.blueprint do
  velocity { 1 }
  name
  start_date { Date.today }
  end_date { Date.today + 14 }
end

Outcome.blueprint do
  description
end

Precondition.blueprint do
  description
end

Precondition.blueprint(:longer) do
  description { Sham.long_description }
end

Release.blueprint do
  release_date { Date.today + 20 }
  notes
end

User.blueprint do
  login
  email
  password { 'monkey' }
  password_confirmation { 'monkey' }
end

User.blueprint(:quentin) do
  login 'quentin'
  salt { '356a192b7913b04c54574d18c28d46e6395428ab' }
  crypted_password { 'caca9d7480e94bdd00036b4da5cdc3bb3e96da7f' }
  created_at { 5.days.ago.to_s :db  }
  remember_token_expires_at { 1.days.from_now.to_s }
  remember_token { '77de68daecd823babbb58edb1c8e14d7106e83bb' }
end

UserRole.blueprint do
  name
end

Scenario.blueprint do
  title
end

Story.blueprint do
  title
  iteration
  description
  points { 2 }
  author { User.make }
end

Story.blueprint(:in_progress) do
  status { 'in_progress' }
end

Story.blueprint(:completed) do
  status { 'completed' }
end

Outcome.blueprint do
  description
end

Precondition.blueprint do
  description
end

module Factory
  class << self

    def make_story(story_options = {})
      story = Story.make(story_options)
      2.times { story.scenarios << make_scenario(story) }
      return story
    end

    def make_scenario(story)
      scenario = Scenario.make(:story => story)
      scenario.preconditions.make
      scenario.preconditions.make(:longer)
      2.times { scenario.outcomes.make }
      return scenario
    end

  end
end

