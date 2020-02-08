# frozen_string_literal: true

require "test_helper"
require "webpack/dev_server/proxy"

class Webpack::DevServer::ProxyTest < MiniTest::Test
  include Rack::Test::Methods

  class App
    def call(env)
      case env["PATH_INFO"]
      when "/"
        [200, { "Content-Type" => "plain/text" }, ["OK"]]
      else
        [404, { "Content-Type" => "plain/text" }, ["Not Found"]]
      end
    end
  end

  def app
    Webpack::DevServer::Proxy.new(App.new, ssl_verify_none: true)
  end

  def test_access_no_proxy_path
    get "/"
    assert_equal 200, last_response.status
    assert_equal "OK", last_response.body

    get "/not_found"
    assert_equal 404, last_response.status
    assert_equal "Not Found", last_response.body
  end

  # rubocop:disable Metrics/AbcSize
  def test_access_proxy_path
    mock_dev_server(fixture_path("files")) do |srv|
      Webpack::DevServer.configure do |config|
        config.url = "http://#{srv.host_with_port}"
        config.proxy_path = "/remote/"
      end

      get "/remote/manifest.json"
      assert_equal 200, last_response.status
      assert_equal "/manifest.json", last_request.env["PATH_INFO"]
      assert_equal srv.host_with_port, last_request.env["HTTP_HOST"]
      assert_equal srv.host_with_port, last_request.env["HTTP_X_FORWARDED_HOST"]
      assert_equal srv.host_with_port, last_request.env["HTTP_X_FORWARDED_SERVER"]
      assert_equal "http", last_request.env["HTTP_X_FORWARDED_PROTO"]
      assert_equal "http", last_request.env["HTTP_X_FORWARDED_SCHEME"]
    end
  end
  # rubocop:enable Metrics/AbcSize

  def test_access_proxy_path_when_proxy_path_false
    mock_dev_server(fixture_path("files")) do |srv|
      Webpack::DevServer.configure do |config|
        config.url = "http://#{srv.host_with_port}"
        config.proxy_path = false
      end

      get "/remote/manifest.json"
      assert_equal 404, last_response.status
    end
  end
end
