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

# Test requirements
group :test do
  gem 'database_cleaner'
  gem 'debugger'
  gem 'faker'
  gem 'machinist'
  gem 'minitest', :require => "minitest/autorun"
  gem 'minitest-matchers'
  gem 'rack-test', :require => "rack/test"
  gem 'turn'
  gem 'valid_attribute'
end

# Padrino Stable Gem
gem 'padrino', '0.10.7'

# Or Padrino Edge
# gem 'padrino', :git => 'git://github.com/padrino/padrino-framework.git'

# Or Individual Gems
# %w(core gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.10.7'
# end
