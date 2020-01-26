# frozen_string_literal: true

require "test_helper"
require "webpack/manifest/entries"

class Webpack::Manifest::EntriesTest < Minitest::Test
  def setup
    @manifest = Webpack::Manifest::Entries.new(
      "bundle.js" => "/packs/bundle-digest.js"
    )
  end

  def test_lookup
    assert_equal "/packs/bundle-digest.js", @manifest.lookup("bundle.js")
    assert_nil @manifest.lookup("unknown.js")
  end

  def test_lookup!
    assert_equal "/packs/bundle-digest.js", @manifest.lookup!("bundle.js")

    # errors
    assert_raises Webpack::Manifest::Entries::MissingEntryError do
      @manifest.lookup!("unknown.js")
    end
  end
end
