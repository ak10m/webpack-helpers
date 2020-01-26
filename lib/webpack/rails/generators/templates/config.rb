# frozen_string_literal: true

require "webpack/helpers"

Webpacky.configure do |config|
  config.dev_server.url = ENV.fetch("WEBPACK_DEV_SERVER_URL") { "http://0.0.0.0:8080" }
  config.dev_server.connect_timeout = ENV.fetch("WEBPACK_DEV_SERVER_CONNECT_TIMEOUT") { 0.1 }
  config.dev_server.proxy_path = ENV.fetch("WEBPACK_DEV_SERVER_PROXY_PATH") { "/webpack/" }

  config.manifest.url = ENV.fetch("WEBPACK_MANIFEST_URL") { "http://0.0.0.0:8080/manifest.json" }
  config.manifest.cache = ENV.fetch("WEBPACK_MANIFEST_CACHE") { Rails.env.production? }
end
