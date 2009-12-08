require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "branston"
    gem.summary = %Q{An experiment in turning user stories into cucumber files}
    gem.description = %Q{Cucumber and more!}
    gem.email = "dave.hrycyszyn@headlondon.com"
    gem.homepage = "http://github.com/futurechimp/branston"
    gem.authors = ["dave.hrycyszyn@headlondon.com", "dan@dangarland.co.uk", "steve.laing@gmail.com"]
    gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    gem.add_dependency "activesupport", ">= 2.3.0"
    gem.add_dependency "cucumber", "=0.4.4"
    gem.files = FileList['lib/**/*'].to_a
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "branston #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

