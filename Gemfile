source :rubygems

# Server requirements
# gem 'thin' # or mongrel
# gem 'trinidad', :platform => 'jruby'

# Project requirements
gem 'rake'
gem 'sinatra-flash', :require => 'sinatra/flash'

# Component requirements
gem 'compass'
gem 'erubis', "~> 2.7.0"
gem 'activerecord', :require => "active_record"
gem 'mysql2'

group :development do
  gem 'thin'
  gem 'debugger'
  gem 'faker'
  gem 'capistrano'
  gem 'capistrano-ext'
  gem "capistrano_colors"
  gem 'rvm-capistrano'
end

# Test requirements
group :test do
  gem 'database_cleaner'
  gem 'debugger'
  gem 'faker'
  gem 'machinist'
  gem 'minitest', "~>2.6.0", :require => "minitest/autorun"
  gem 'minitest-matchers'
  gem 'rack-test', :require => "rack/test"
  gem 'turn', "~> 0.9.5"
end

# Padrino Stable Gem
gem 'padrino', '0.10.7'