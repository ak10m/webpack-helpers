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
    mock_dev_server(fixture_path("files")) do |srv|
      remote_url = "http://#{srv.host_with_port}/manifest.json"
      Webpack::Manifest.configure do |c|
        c.url = remote_url
      end
      assert_instance_of Webpack::Manifest::Entries, Webpack::Manifest.load(remote_url)
    end
  end

  def test_load_when_given_invalid_uri
    assert_raises URI::InvalidURIError do
      Webpack::Manifest.load "invalid uri"
    end
  end
end
