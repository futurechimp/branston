require File.dirname(__FILE__) + "/config/environment"
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :dbfile =>  '/home/dave/thing.db'
)
#use Rails::Rack::LogTailer
use Rails::Rack::Static
run ActionController::Dispatcher.new

