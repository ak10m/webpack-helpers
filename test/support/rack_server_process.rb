# frozen_string_literal: true

require "socket"
require "rack"

class RackServerProcess < Rack::Server
  def initialize(options = {})
    environment  = ENV["RACK_ENV"] || "development"
    default_host = environment == "development" ? "localhost" : "0.0.0.0"
    random_port = Addrinfo.tcp("", 0).bind { |s| s.local_address.ip_port }
    pid_file = File.expand_path("./tmp/rack-#{random_port}.pid")
    super({
      Host: default_host,
      Port: random_port,
      pid: pid_file,
      daemonize: true
    }.merge(options))
  end

  def host
    options[:Host]
  end

  def port
    options[:Port]
  end

  def host_with_port
    "#{host}:#{port}"
  end

  def pid
    ::File.exist?(options[:pid]) ? ::File.read(options[:pid]).to_i : nil
  end

  def run(timeout: 10)
    Process.fork { start }
    wait(timeout: timeout)
    yield self
  ensure
    stop
  end

  def stop
    return if pid.nil?

    Process.kill "SIGTERM", pid
    ::File.delete(options[:pid])
  end

  private

  def wait(timeout: 10, interval: 1)
    Timeout.timeout(timeout) do
      loop do
        Socket.tcp(host, port).close
        break
      rescue StandardError
        sleep interval
        retry
      end
    end
  end
end
