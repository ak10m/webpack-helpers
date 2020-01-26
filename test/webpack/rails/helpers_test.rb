# frozen_string_literal: true

require "test_helper"
require "webpack/rails/helpers"

if defined?(Rails)
  require "action_view"

  # rubocop:disable Metrics/ClassLength
  class Webpack::Rails::HelpersTest < ActionView::TestCase
    setup do
      @script_manifest = Webpack::Manifest::Entries.new(
        "relative.js" => "relative-digest.js",
        "absolute.js" => "/bundles/absolute-digest.js",
        "remote.js" => "https://cdn/remote-digest.js"
      )
      @style_manifest = Webpack::Manifest::Entries.new(
        "relative.css" => "relative-digest.css",
        "absolute.css" => "/bundles/absolute-digest.css",
        "remote.css" => "https://cdn/remote-digest.css"
      )
      @image_manifest = Webpack::Manifest::Entries.new(
        "relative.svg" => "relative-digest.svg",
        "absolute.svg" => "/bundles/absolute-digest.svg",
        "remote.svg" => "https://cdn/remote-digest.svg"
      )
    end

    test "javascript_bundle_tag" do
      Webpack.stub :manifest, @script_manifest do
        Webpack.config.stub :dev_server, Webpack::DevServer::Configuration.new do
          Webpack.configure do |c|
            c.dev_server.proxy_path = "/web/pack/"
          end

          assert_equal %(<script src="/web/pack/relative-digest.js"></script>),
                       view.javascript_bundle_tag("relative")
          assert_equal %(<script src="/web/pack/bundles/absolute-digest.js"></script>),
                       view.javascript_bundle_tag("absolute")
          assert_equal %(<script src="https://cdn/remote-digest.js"></script>),
                       view.javascript_bundle_tag("remote")

          multiple_expected = <<~EXPECTED.chomp
            <script src="/web/pack/relative-digest.js"></script>
            <script src="/web/pack/bundles/absolute-digest.js"></script>
            <script src="https://cdn/remote-digest.js"></script>
          EXPECTED
          assert_equal multiple_expected, view.javascript_bundle_tag("relative", "absolute", "remote")

          assert_raise Webpack::Manifest::Entries::MissingEntryError do
            view.javascript_bundle_tag("unknown")
          end
        end
      end
    end

    test "javascript_bundle_tag when proxy_path is falsy" do
      Webpack.stub :manifest, @script_manifest do
        Webpack.config.stub :dev_server, Webpack::DevServer::Configuration.new do
          Webpack.configure do |c|
            c.dev_server.proxy_path = false
          end

          assert_equal %(<script src="/javascripts/relative-digest.js"></script>),
                       view.javascript_bundle_tag("relative")
          assert_equal %(<script src="/bundles/absolute-digest.js"></script>),
                       view.javascript_bundle_tag("absolute")
          assert_equal %(<script src="https://cdn/remote-digest.js"></script>),
                       view.javascript_bundle_tag("remote")

          multiple_expected = <<~EXPECTED.chomp
            <script src="/javascripts/relative-digest.js"></script>
            <script src="/bundles/absolute-digest.js"></script>
            <script src="https://cdn/remote-digest.js"></script>
          EXPECTED
          assert_equal multiple_expected, view.javascript_bundle_tag("relative", "absolute", "remote")

          assert_raise Webpack::Manifest::Entries::MissingEntryError do
            view.javascript_bundle_tag("unknown")
          end
        end
      end
    end

    test "stylesheet_bundle_tag" do
      Webpack.stub :manifest, @style_manifest do
        Webpack.config.stub :dev_server, Webpack::DevServer::Configuration.new do
          Webpack.configure do |c|
            c.dev_server.proxy_path = "/web/pack/"
          end

          assert_equal %(<link rel="stylesheet" media="screen" href="/web/pack/relative-digest.css" />),
                       view.stylesheet_bundle_tag("relative")
          assert_equal %(<link rel="stylesheet" media="screen" href="/web/pack/bundles/absolute-digest.css" />),
                       view.stylesheet_bundle_tag("absolute")
          assert_equal %(<link rel="stylesheet" media="screen" href="https://cdn/remote-digest.css" />),
                       view.stylesheet_bundle_tag("remote")

          multiple_expected = <<~EXPECTED.chomp
            <link rel="stylesheet" media="screen" href="/web/pack/relative-digest.css" />
            <link rel="stylesheet" media="screen" href="/web/pack/bundles/absolute-digest.css" />
            <link rel="stylesheet" media="screen" href="https://cdn/remote-digest.css" />
          EXPECTED
          assert_equal multiple_expected, view.stylesheet_bundle_tag("relative", "absolute", "remote")

          assert_raise Webpack::Manifest::Entries::MissingEntryError do
            view.stylesheet_bundle_tag("unknown")
          end
        end
      end
    end

    test "stylesheet_bundle_tag when proxy_path is falsy" do
      Webpack.stub :manifest, @style_manifest do
        Webpack.config.stub :dev_server, Webpack::DevServer::Configuration.new do
          Webpack.configure do |c|
            c.dev_server.proxy_path = false
          end

          assert_equal %(<link rel="stylesheet" media="screen" href="/stylesheets/relative-digest.css" />),
                       view.stylesheet_bundle_tag("relative")
          assert_equal %(<link rel="stylesheet" media="screen" href="/bundles/absolute-digest.css" />),
                       view.stylesheet_bundle_tag("absolute")
          assert_equal %(<link rel="stylesheet" media="screen" href="https://cdn/remote-digest.css" />),
                       view.stylesheet_bundle_tag("remote")

          multiple_expected = <<~EXPECTED.chomp
            <link rel="stylesheet" media="screen" href="/stylesheets/relative-digest.css" />
            <link rel="stylesheet" media="screen" href="/bundles/absolute-digest.css" />
            <link rel="stylesheet" media="screen" href="https://cdn/remote-digest.css" />
          EXPECTED
          assert_equal multiple_expected, view.stylesheet_bundle_tag("relative", "absolute", "remote")

          assert_raise Webpack::Manifest::Entries::MissingEntryError do
            view.stylesheet_bundle_tag("unknown")
          end
        end
      end
    end

    test "image_bundle_tag" do
      Webpack.stub :manifest, @image_manifest do
        Webpack.config.stub :dev_server, Webpack::DevServer::Configuration.new do
          Webpack.configure do |c|
            c.dev_server.proxy_path = "/web/pack/"
          end

          assert_equal %(<img alt="relative" src="/web/pack/relative-digest.svg" />),
                       view.image_bundle_tag("relative.svg", alt: "relative")
          assert_equal %(<img alt="absolute" src="/web/pack/bundles/absolute-digest.svg" />),
                       view.image_bundle_tag("absolute.svg", alt: "absolute")
          assert_equal %(<img alt="remote" src="https://cdn/remote-digest.svg" />),
                       view.image_bundle_tag("remote.svg", alt: "remote")

          assert_raise Webpack::Manifest::Entries::MissingEntryError do
            view.image_bundle_tag("unknown.svg")
          end
        end
      end
    end

    test "image_bundle_tag when proxy_path is falsy" do
      Webpack.stub :manifest, @image_manifest do
        Webpack.config.stub :dev_server, Webpack::DevServer::Configuration.new do
          Webpack.configure do |c|
            c.dev_server.proxy_path = false
          end

          assert_equal %(<img alt="relative" src="/images/relative-digest.svg" />),
                       view.image_bundle_tag("relative.svg", alt: "relative")
          assert_equal %(<img alt="absolute" src="/bundles/absolute-digest.svg" />),
                       view.image_bundle_tag("absolute.svg", alt: "absolute")
          assert_equal %(<img alt="remote" src="https://cdn/remote-digest.svg" />),
                       view.image_bundle_tag("remote.svg", alt: "remote")

          assert_raise Webpack::Manifest::Entries::MissingEntryError do
            view.image_bundle_tag("unknown.svg")
          end
        end
      end
    end
  end
  # rubocop:enable Metrics/ClassLength
end
