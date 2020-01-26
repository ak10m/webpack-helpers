# frozen_string_literal: true

module Webpack::Manifest
  class Configuration
    attr_accessor :url, :cache

    def initialize
      @url = ENV.fetch("WEBPACK_MANIFEST_URL") { "/path/to/manifest.json" }
      @cache = ENV.fetch("WEBPACK_MANIFEST_CACHE", false)
    end
  end
end
