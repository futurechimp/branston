require 'machinist/active_record'
require 'sham'
require 'faker'

# Shams - generated filler values
#
Sham.define do
  name            { Faker::Lorem.words }
  title           { Faker::Lorem.words }
  description     { Faker::Lorem.sentences }
  email           { Faker::Internet.email }
  login           { Faker::Name.first_name }
end

# Model class blueprints

Iteration.blueprint do
  velocity { 1 }
  name
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

Story.blueprint do
  title
  description
  points { 2 }
end

Story.blueprint(:in_progress) do
  description
  points { 2 }
  iteration
end

