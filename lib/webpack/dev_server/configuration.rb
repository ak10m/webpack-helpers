# frozen_string_literal: true

module Webpack::DevServer
  class Configuration
    attr_accessor :url, :connect_timeout, :proxy_path

    def initialize
      @url = ENV.fetch("WEBPACK_DEV_SERVER_URL") { "http://0.0.0.0:8080" }
      @connect_timeout = ENV.fetch("WEBPACK_DEV_SERVER_CONNECT_TIMEOUT") { 0.1 }
      @proxy_path = ENV.fetch("WEBPACK_DEV_SERVER_PROXY_PATH") { "/webpack/" }
    end
  end
end
