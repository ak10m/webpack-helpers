# frozen_string_literal: true

require "rack/file"

run Rack::File.new(File.expand_path("files", __dir__))
