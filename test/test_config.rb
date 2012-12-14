PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path('../../config/boot', __FILE__)

class MiniTest::Unit::TestCase
  include Rack::Test::Methods
  include MiniTest::Assertions::ActiveRecord
  include ::ValidAttribute::Method
  DatabaseCleaner.strategy = :transaction

  Padrino.mounted_apps.each do |app|
    puts "=> Loading Application #{app.app_class}"
    app.app_obj.setup_application!
  end

  def app
    Padrino.application
  end

  def setup
    DatabaseCleaner.start
    # # BUG: this is bullshit and shouldn't be necessary
    # # (Admin.setup_application! should take care of it)
    # # but seems to be needed, otherwise we get a 404 on
    # # the first request (!).
    # get Branston.url(:projects, :index)
  end

  def teardown
    DatabaseCleaner.clean

    # Remove the test public folder after every test run.
    #
    # FileUtils.rm_rf(Branston.uploads_path)
  end
end
