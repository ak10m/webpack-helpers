# frozen_string_literal: true

require "webpack/dev_server"
require "webpack/manifest"

module Webpack
  class Configuration
    attr_accessor :dev_server, :manifest

    def initialize
      @dev_server = Webpack::DevServer.config
      @manifest = Webpack::Manifest.config
    end
  end
end
