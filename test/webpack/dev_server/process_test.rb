# frozen_string_literal: true

require "test_helper"
require "socket"
require "webpack/dev_server/process"

class Webpack::DevServer::ProcessTest < MiniTest::Test
  def test_initialize_when_given_invalid_address
    assert_raises URI::InvalidURIError do
      Webpack::DevServer::Process.new "invalid address"
    end
  end

  def test_initialize_when_given_unsupported_address
    e = assert_raises Webpack::DevServer::Process::UnsupportedAddressError do
      Webpack::DevServer::Process.new "unsupport://localhost:9999"
    end
    assert_equal "`unsupport://localhost:9999` is unsupported address.", e.message
  end

  def test_initialize_http_address
    srv = Webpack::DevServer::Process.new "http://localhost"

    assert_equal URI::HTTP.build(host: "localhost"), srv.uri
    assert_equal "http", srv.protocol
    refute srv.https?
    assert_equal "localhost", srv.host
    assert_equal 80, srv.port
    assert_equal "localhost:80", srv.host_with_port
  end

  def test_initialize_https_address
    srv = Webpack::DevServer::Process.new "https://secure"

    assert_equal URI::HTTPS.build(host: "secure"), srv.uri
    assert_equal "https", srv.protocol
    assert srv.https?
    assert_equal "secure", srv.host
    assert_equal 443, srv.port
    assert_equal "secure:443", srv.host_with_port
  end

  def test_initialize_stric_address
    srv = Webpack::DevServer::Process.new "https://example:8080"

    assert_equal URI::HTTPS.build(host: "example", port: 8080), srv.uri
    assert_equal "https", srv.protocol
    assert srv.https?
    assert_equal "example", srv.host
    assert_equal 8080, srv.port
    assert_equal "example:8080", srv.host_with_port
  end

  def test_running_when_connected
    srv = Webpack::DevServer::Process.new "http://test"

    connected = Minitest::Mock.new.expect :close, nil
    Socket.stub :tcp, connected do
      assert srv.running?
    end
  end

  def test_running_when_raise_connection_refused
    srv = Webpack::DevServer::Process.new "http://test"

    raise_connection_refused = -> { raise Errno::ECONNREFUSED }
    Socket.stub :tcp, raise_connection_refused do
      refute srv.running?
    end
  end

  def test_running_when_raise_connection_timeout
    srv = Webpack::DevServer::Process.new "http://test"

    raise_connection_timeout = -> { raise Errno::ETIMEDOUT }
    Socket.stub :tcp, raise_connection_timeout do
      refute srv.running?
    end
  end
end
