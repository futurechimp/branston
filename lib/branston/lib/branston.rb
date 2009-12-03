require File.dirname(__FILE__) + '/../lib/client'

class Branston

  PORT=3970
  attr_accessor :args

  def initialize(args)
    self.args = args
    go()
  end

  def go
    if args.empty?
      usage
    else
      if args[0] == "server"
        puts "Starting Branston Server on port http://localhost:#{PORT}/"
        system("ruby #{File.dirname(__FILE__)}/../script/server -p #{PORT} -e production &>> /dev/null &")
      elsif args[0] == 'generate'
        Client.new(*args)
      else
        usage
      end
    end
  end

  private
  def usage
    puts "usage: branston server"
  end
end

