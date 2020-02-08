# frozen_string_literal: true

require "socket"
require "rack/server"
require "rack/file"

module Webpack
  module Testing
    class FileServer < ::Rack::Server
      def initialize(root)
        port = unused_port
        pid = File.expand_path("./tmp/rack-#{port}.pid")
        super(
          app: ::Rack::File.new(root),
          Host: default_host,
          Port: port,
          pid: pid,
          daemonize: true
        )
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

      def running?
        Socket.tcp(host, port).close
        true
      rescue Errno::ECONNREFUSED
        false
      end

      def run(timeout: 10)
        Process.fork { start } unless running?
        wait timeout

        return unless block_given?

        yield self
        stop
      end

      def stop
        return if pid.nil?

        Process.kill "SIGTERM", pid
        ::File.delete(options[:pid])
      end

      private

      def wait(timeout, interval: 1)
        Timeout.timeout(timeout) do
          loop do
            break if running?

            sleep interval
          end
        end
      end

      def default_host
        env = ENV["RACK_ENV"] || "development"
        env == "development" ? "localhost" : "0.0.0.0"
      end

      def unused_port
        Addrinfo.tcp("", 0).bind { |s| s.local_address.ip_port }
      end
    end
  end
end
