# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "webpack/helpers"

require "minitest/autorun"

(Dir[File.expand_path("support/**/*.rb", __dir__)]).each { |f| require f }
