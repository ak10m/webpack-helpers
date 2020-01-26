# frozen_string_literal: true

module Webpack
  module DevServer
    class << self
      def configure
        yield config
      end

      def config
        @config ||= Configuration.new
      end

      def process
        Webpack::DevServer::Process.new config.url, timeout: config.connect_timeout
      end
    end
  end
end

require "webpack/dev_server/configuration"
require "webpack/dev_server/process"
