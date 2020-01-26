# frozen_string_literal: true

require "test_helper"
require "webpack/manifest/entries"

class Webpack::ManifestTest < Minitest::Test
  def test_load_from_local_file
    # load file
    file_path = fixture_path "files/manifest.json"
    assert_instance_of Webpack::Manifest::Entries, Webpack::Manifest.load(file_path)
  end

  def test_load_from_remote_file
    remote_server = RackServerProcess.new(config: fixture_path("files.ru"))
    remote_server.run do |rs|
      remote_url = "http://#{rs.host_with_port}/manifest.json"
      assert_instance_of Webpack::Manifest::Entries, Webpack::Manifest.load(remote_url)
    end
  end

  def test_load_when_given_invalid_uri
    assert_raises URI::InvalidURIError do
      Webpack::Manifest.load "invalid uri"
    end
  end
end
