# frozen_string_literal: true

require "test_helper"
require "webpack"
require "webpack/helpers"

class Webpack::HelpersTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Webpack::Helpers::VERSION
  end

  class Helper
    include Webpack::Helpers
  end

  def setup
    @helper = Helper.new
    @manifest = Webpack::Manifest::Entries.new(
      "script.js" => "script-digest.js",
      "style.css" => "/bundles/style-digest.css",
      "logo.svg" => "https://cdn/images/logo-digest.svg"
    )
  end

  def test_webpack_bundle_path
    Webpack.config.stub :dev_server, Webpack::DevServer::Configuration.new do
      Webpack.configure do |c|
        c.dev_server.proxy_path = "/web/pack/"
      end

      Webpack.stub :manifest, @manifest do
        assert_equal "/web/pack/script-digest.js", @helper.webpack_bundle_path("script.js")
        assert_equal "/web/pack/bundles/style-digest.css", @helper.webpack_bundle_path("style.css")
        assert_equal "https://cdn/images/logo-digest.svg", @helper.webpack_bundle_path("logo.svg")
        assert_equal "/web/pack/manifest.json", @helper.webpack_bundle_path("manifest.json")
      end
    end
  end

  def test_webpack_bundle_path_when_no_proxy_path
    Webpack.config.stub :dev_server, Webpack::DevServer::Configuration.new do
      Webpack.configure do |c|
        c.dev_server.proxy_path = false
      end

      Webpack.stub :manifest, @manifest do
        assert_equal "script-digest.js", @helper.webpack_bundle_path("script.js")
        assert_equal "/bundles/style-digest.css", @helper.webpack_bundle_path("style.css")
        assert_equal "https://cdn/images/logo-digest.svg", @helper.webpack_bundle_path("logo.svg")
        assert_equal "manifest.json", @helper.webpack_bundle_path("manifest.json")
      end
    end
  end
end
