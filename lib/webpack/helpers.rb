# frozen_string_literal: true

require "webpack"

module Webpack
  module Helpers
    def webpack_bundle_path(entry)
      lookuped = URI.parse Webpack.manifest.lookup!(entry)
      prefix = Webpack.config.dev_server.proxy_path

      return lookuped.to_s unless lookuped.host.nil? && prefix

      Pathname.new("/#{prefix}/#{lookuped}").cleanpath.to_s
    end
  end
end

require "webpack/railtie" if defined? Rails
