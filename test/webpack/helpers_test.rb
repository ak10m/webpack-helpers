# frozen_string_literal: true

require "test_helper"

class Webpack::HelpersTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Webpack::Helpers::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
