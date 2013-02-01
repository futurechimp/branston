# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rdoc/task'

require 'tasks/rails'

require 'rcov/rcovtask'

task :default => [:rcov]

Rcov::RcovTask.new do |t|
  t.test_files = FileList['test/**/*test.rb']
  t.rcov_opts << "--sort coverage --failure-threshold=98 -Ilib:test --rails"
  t.rcov_opts << "--exclude '/gems/,/usr/,/Library,lib/authenticated_test_helper.rb,lib/authenticated_system.rb,app/helpers/users_helper.rb'"
end
