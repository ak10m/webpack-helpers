# frozen_string_literal: true

require "rails/generators"

module Webpack
  module Generators
    # rails g webpack:install
    class ConfigGenerator < ::Rails::Generators::Base # :nodoc:
      source_root File.expand_path(File.join(File.dirname(__FILE__), "templates"))

      desc <<~DESC
        Description:
          Copies Webpack configuration file to your application's initializer directory.
      DESC

      def copy_initializer
        template "config.rb", "config/initializers/webpack.rb"
      end
    end
  end
end
