PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path('../../config/boot', __FILE__)

class MiniTest::Unit::TestCase
  include Rack::Test::Methods
  include MiniTest::ActiveRecordAssertions
  include ::ValidAttribute::Method
  DatabaseCleaner.strategy = :transaction

  Padrino.mounted_apps.each do |app|
    puts "=> Loading Application #{app.app_class}"
    app.app_obj.setup_application!
  end

  def app
    ##
    # You can handle all padrino applications using instead:
    #   Padrino.application
    Branston.tap { |app|  }
  end

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
