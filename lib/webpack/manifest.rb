# frozen_string_literal: true

module Webpack
  module Manifest
    class << self
      def configure
        yield config
      end

      def config
        @config ||= Configuration.new
      end

      def load(path)
        # read file
        uri = URI.parse(path.to_s)
        str = case uri
              when URI::HTTP, URI::HTTPS
                OpenURI.open_uri(uri.to_s).read
              else # default read file
                File.read(uri.path)
              end

        # to json
        entries = JSON.parse str

        # return Manifest instance
        Entries.new entries
      end
    end
  end
end

require "webpack/manifest/configuration"
require "webpack/manifest/entries"
