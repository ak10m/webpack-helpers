# frozen_string_literal: true

require "rack"
require "webpack/helpers"
require "webpack/dev_server/proxy"

class Application
  include Webpack::Helpers

  def call(env)
    case env["PATH_INFO"]
    when "/"
      [200, { "Content-Type" => "text/html" }, [body.strip]]
    when "/favicon.ico"
      [200, { "Content-Type" => "image/vnd.microsoft.icon" }, []]
    else
      [404, { "Content-Type" => "text/plain" }, []]
    end
  end

  private

  def body
    <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
          <title>Example</title>
        </head>
        <body>
          <h1>Webpacky on Rack Application Example</h1>
          <div id="hello"></div>
        </body>
        <script src="#{webpack_bundle_path('main.js')}"></script>
      </html>
    HTML
  end
end

use Webpack::DevServer::Proxy, ssl_verify_none: true

run Application.new
