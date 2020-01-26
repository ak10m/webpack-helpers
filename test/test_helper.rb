# frozen_string_literal: true

ENV["RACK_ENV"] ||= "test"

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "webpack/helpers"

require "minitest/autorun"
require "rack"
require "rack/test"

(Dir[File.expand_path("support/**/*.rb", __dir__)]).each { |f| require f }
