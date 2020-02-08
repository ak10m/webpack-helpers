# frozen_string_literal: true

require "webpack/testing/helper"

Minitest::Test.include Webpack::Testing::Helper if defined? Minitest::Test
