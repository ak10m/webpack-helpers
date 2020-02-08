# frozen_string_literal: true

require "webpack/dev_server"
require "webpack/manifest"
require "webpack/testing/file_server"

module Webpack
  module Testing
    module Helper
      def mock_dev_server(root_path)
        Webpack::DevServer.stub :config, Webpack::DevServer::Configuration.new do
          Webpack::Manifest.stub :config, Webpack::Manifest::Configuration.new do
            Webpack::Testing::FileServer.new(root_path).run do |srv|
              yield srv
            end
          end
        end
      end
    end
  end
end
