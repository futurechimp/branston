require 'lib/branston/lib/client'

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
        system("ruby lib/branston/script/server -p #{PORT} -e development &>> /dev/null &")
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

