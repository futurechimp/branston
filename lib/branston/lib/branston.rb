require File.dirname(__FILE__) + '/../lib/client'
require 'optparse'
require 'ftools'

BRANSTON_HOME='/home/daniel/.branston'
PORT = 3970

class Branston
  
  attr_accessor :args
  
  def initialize(args)
    self.args = args
    go()
  end
  
  def go
    
    options = {
      :Port        => PORT,
      :Host        => "0.0.0.0",
      :environment => (ENV['RAILS_ENV'] || "production").dup,
      :detach      => true,
      :debugger    => false,
      :path        => nil
    }
    
    ARGV.clone.options do |opts|
      opts.on("-s", "--server", String, "Run a Branston Server") { 
        opts.on("-p", "--port=port", Integer,
          "Runs Branston on the specified port.", "Default: #{PORT}") { |v| options[:Port] = v }
        opts.on("-b", "--binding=ip", String,
          "Binds Branston to the specified ip.", "Default: 0.0.0.0") { |v| options[:Host] = v }
        opts.on("-P", "--path=/path", String, "Runs Branston mounted at a specific path.", "Default: /") { |v| options[:path] = v }
        @server = true
      }
      opts.on("-g", "--generate", String, "Generate a feature from a Branston Server") { 
         opts.on("-p", "--port=port", Integer,
          "Access a branston server on the specified port.", "Default: #{PORT}") { |v| options[:Port] = v }
        opts.on("-b", "--binding=ip", String,
          "Access a branston server on the specified ip.", "Default: 0.0.0.0") { |v| options[:Host] = v }
        opts.on("-f", "--feature=id", Integer,
          "Generate a feature for the given story id.") { |v| options[:feature_id] = v }
        @generator = true
      }
      opts.separator ""
      opts.on("-h", "--help", "Show this help message.") { puts opts; exit }
      opts.parse!
      
      if ARGV.empty? or (!@server and !@generator) or (@server and @generator)
        puts opts; exit       
      end
    end
    
    if @server
      launch_branston_server(options)
    elsif @generator
      Client.new(options).generate_story_files
    end
  end
  
  private
  
  def launch_branston_server(options)
    require 'active_support'
    require 'action_controller'

    File.makedirs BRANSTON_HOME
    
    # TODO: Push Thin adapter upstream so we don't need worry about requiring it
    begin
      require_library_or_gem 'thin'
    rescue Exception
      # Thin not available
    end
    
    server = Rack::Handler.get(ARGV.first) rescue nil
    unless server
      begin
        server = Rack::Handler::Mongrel
      rescue LoadError => e
        server = Rack::Handler::WEBrick
      end
    end
    
    puts "Branston server starting on http://#{options[:Host]}:#{options[:Port]}#{options[:path]}"
    
    %w(cache pids sessions sockets).each do |dir_to_make|
      FileUtils.mkdir_p(File.join(BRANSTON_HOME, dir_to_make))
    end
    
    # Process.daemon
    # pid = BRANSTON_HOME + "/pids/server.pid"
    # File.open(pid, 'w'){ |f| f.write(Process.pid) }
    # at_exit { File.delete(pid) if File.exist?(pid) }
    
    ENV["RAILS_ENV"] = options[:environment]
    RAILS_ENV.replace(options[:environment]) if defined?(RAILS_ENV)
    
    require File.dirname(__FILE__) + "/../config/environment"
    
    File.copy File.dirname(__FILE__) + "/../db/development.sqlite3", 
    BRANSTON_HOME + "/branston.sqlite3" unless File.exists? BRANSTON_HOME + "/branston.sqlite3"
    
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database =>  BRANSTON_HOME + '/branston.sqlite3',
      :pool => 5,
      :timeout => 5000
      )
    inner_app = ActionController::Dispatcher.new
    
    if options[:path].nil?
      map_path = "/"
    else
      ActionController::Base.relative_url_root = options[:path]
      map_path = options[:path]
    end
    
    app = Rack::Builder.new {    
      map map_path do
        use Rails::Rack::Static 
        run inner_app
      end
    }.to_app
    
    trap(:INT) { exit }
    
    begin
      server.run(app, options.merge(:AccessLog => []))
    ensure
      puts 'Goodbye'
    end
  end
end

