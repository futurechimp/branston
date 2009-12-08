require File.dirname(__FILE__) + '/../lib/client'
require 'optparse'
require 'ftools'

BRANSTON_HOME= Dir.pwd + '/.branston'
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
      :path        => nil,
      :directory   => BRANSTON_HOME
    }
    
    actions = []
    
    ARGV.clone.options do |opts|
      opts.on("-i", "--init", String, "Initialise Branston") {
        opts.on("-w", "--working=directory", String, "Initialise branston in the given " + 
          "directory", "Default: .branston") { |v| options[:directory] =v }
        actions << 'init'
      }
      opts.on("-s", "--server", String, "Run a Branston Server") { 
        opts.on("-p", "--port=port", Integer,
          "Runs Branston on the specified port.", "Default: #{PORT}") { |v| options[:Port] = v }
        opts.on("-b", "--binding=ip", String,
          "Binds Branston to the specified ip.", "Default: 0.0.0.0") { |v| options[:Host] = v }
        opts.on("-P", "--path=/path", String, "Runs Branston mounted at a specific path.", "Default: /") { |v| options[:path] = v }
        opts.on("-w", "--working=directory", String, "Run branston in the given " + 
          "directory, the same directory that you branston --initialised into", "Default: .branston") { |v| options[:directory] =v }
        actions << 'server'
      }
      opts.on("-g", "--generate", String, "Generate a feature from a Branston Server") { 
         opts.on("-p", "--port=port", Integer,
          "Access a branston server on the specified port.", "Default: #{PORT}") { |v| options[:Port] = v }
        opts.on("-b", "--binding=ip", String,
          "Access a branston server on the specified ip.", "Default: 0.0.0.0") { |v| options[:Host] = v }
        opts.on("-f", "--feature=name", String,
          "Generate a feature for the given story regular expression.") { |v| options[:feature] = v }
        actions << 'generator'
      }
      opts.separator ""
      opts.on("-h", "--help", "Show this help message.") { puts opts; exit }
      opts.parse!
      
      if ARGV.empty? or actions.size != 1
        puts opts; exit       
      end
    end
    
    if actions.first == 'server'
      launch_branston_server(options)
    elsif actions.first == 'generator'
      Client.new(options).generate_story_files
    elsif actions.first == 'init'
      initialise_branston(options)
    end
  end
  
  private
  
  def initialise_branston(options)
    File.makedirs options[:directory]
    unless File.exists? options[:directory] + "/branston.sqlite3"
      File.copy File.dirname(__FILE__) + "/../db/development.sqlite3", 
      options[:directory] + "/branston.sqlite3"
    end
    
    %w(cache pids sessions sockets).each do |dir_to_make|
      FileUtils.mkdir_p(File.join(options[:directory], dir_to_make))
    end
    
    puts "Successfully initialised branston in #{options[:directory]}"
  end
  
  def launch_branston_server(options)
    require 'active_support'
    require 'action_controller'

    server = Rack::Handler.get(ARGV.first) rescue nil
    unless server
      begin
        server = Rack::Handler::Mongrel
      rescue LoadError => e
        server = Rack::Handler::WEBrick
      end
    end
    
    puts "Branston server starting on http://#{options[:Host]}:#{options[:Port]}#{options[:path]}"
    
    # Process.daemon
    # pid = options[:directory] + "/pids/server.pid"
    # File.open(pid, 'w'){ |f| f.write(Process.pid) }
    # at_exit { File.delete(pid) if File.exist?(pid) }
    
    ENV["RAILS_ENV"] = options[:environment]
    RAILS_ENV.replace(options[:environment]) if defined?(RAILS_ENV)
    
    require File.dirname(__FILE__) + "/../config/environment"
    
    ActiveRecord::Base.establish_connection(
      :adapter => 'sqlite3',
      :database =>  options[:directory] + '/branston.sqlite3',
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

