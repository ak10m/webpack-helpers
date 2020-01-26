# frozen_string_literal: true

module Webpack
  class << self
    def configure
      yield config
    end

    def config
      @config ||= Configuration.new
    end

    def manifest
      return @manifest if config.manifest.cache && defined?(@manifest)

      @manifest = Webpack::Manifest.load config.manifest.url
    end
  end
end

require "webpack/configuration"
require "webpack/dev_server"
require "webpack/manifest"
