# frozen_string_literal: true

require "pathname"

module FixturesHelper
  def fixture_path(entry)
    Pathname.new(File.expand_path("../fixtures", __dir__)).join(entry).to_s
  end
end

Minitest::Test.include FixturesHelper if defined? Minitest::Test
