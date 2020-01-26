# frozen_string_literal: true

require "uri"
require "socket"

module Webpack::DevServer
  class Process
    class UnsupportedAddressError < StandardError; end

    attr_reader :uri, :timeout

    def initialize(address, timeout: 0.01)
      uri = URI.parse(address.to_s)
      case uri
      when URI::HTTP, URI::HTTPS
        @uri = uri
      else
        raise UnsupportedAddressError, "`#{address}` is unsupported address."
      end

      @timeout = timeout
    end

    def protocol
      uri.scheme
    end

    def https?
      protocol == "https"
    end

    def host
      uri.host
    end

    def port
      uri.port
    end

    def host_with_port
      "#{host}:#{port}"
    end

    def running?
      Socket.tcp(host, port, connect_timeout: timeout).close
      true
    rescue StandardError
      false
    end
  end
end
