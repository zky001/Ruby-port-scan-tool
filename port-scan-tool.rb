require 'socket'
require 'celluloid'

class ScanPort
  include Celluloid

  def initialize(host, start_port, end_port)
    @host = host
    @start_port = start_port
    @end_port = end_port
  end

  def run()
    until @start_port == @end_port do
      scan(@start_port)
      @start_port += 1
    end
  end

  def scan(port)
    begin
      sock = Socket.new(:INET, :STREAM)
      raw = Socket.sockaddr_in(port, @host)
      puts "\033[32m #{port} is alived. \033[0m\n" if sock.connect(raw)

      rescue
        if sock != nil
          sock.close
        end
    end
  end
end

def check_opts()
  if not ARGV[2]
    puts "Please use the following format:"
    puts "\033[80m\truby scanner.rb IP start_port end_port\033[0m\n"
  end
end

def main()
  check_opts()

  host = ARGV[0]
  start_port = ARGV[1].to_i
  end_port = ARGV[2].to_i

  until start_port >= end_port do
    sp = ScanPort.new(host, start_port, start_port+100)
    sp.async.run()

    start_port += 100
  end
end


main()
