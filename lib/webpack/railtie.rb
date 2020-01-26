# frozen_string_literal: true

require "rails/railtie"
require "webpack"

module Webpack
  class Railtie < ::Rails::Railtie
    initializer "webpack.dev_server.proxy" do |app|
      if Webpack.config.dev_server.proxy_path
        require "webpack/dev_server/proxy"
        middleware = ::Rails::VERSION::MAJOR >= 5 ? Webpack::DevServer::Proxy : "Webpack::DevServer::Proxy"
        app.middleware.insert_before 0, middleware, ssl_verify_none: true
      end
    end

    config.after_initialize do
      require "webpack/rails/helpers"
      ActiveSupport.on_load :action_view do
        ::ActionView::Base.include Webpack::Rails::Helpers
      end
    end

    generators do
      require "webpack/rails/generators/config_generator"
    end
  end
end
