# frozen_string_literal: true

require "rack/proxy"
require "webpack/dev_server"

module Webpack::DevServer
  class Proxy < ::Rack::Proxy
    def perform_request(env)
      if proxy?(env)
        env["HTTP_HOST"] = env["HTTP_X_FORWARDED_HOST"] = env["HTTP_X_FORWARDED_SERVER"] = dev_server.host_with_port
        env["HTTP_X_FORWARDED_PROTO"] = env["HTTP_X_FORWARDED_SCHEME"] = dev_server.protocol
        env["HTTPS"] = env["HTTP_X_FORWARDED_SSL"] = "off" unless dev_server.https?
        env["PATH_INFO"] = env["PATH_INFO"].gsub(/^#{proxy_path}/, "/")

        super(env)
      else
        @app.call(env)
      end
    end

    protected

    def config
      ::Webpack::DevServer.config
    end

    def dev_server
      ::Webpack::DevServer.process
    end

    def proxy_path
      config.proxy_path || ""
    end

    def proxy?(env)
      !proxy_path.empty? && env["PATH_INFO"].start_with?(proxy_path)
    end
  end
end
