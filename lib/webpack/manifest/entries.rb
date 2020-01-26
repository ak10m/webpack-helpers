# frozen_string_literal: true

require "open-uri"
require "json"

module Webpack::Manifest
  class Entries
    class MissingEntryError < StandardError; end

    attr_reader :entries

    def initialize(entries)
      @entries = entries
    end

    def lookup(entry)
      entries.fetch(entry) { nil }
    end

    def lookup!(entry)
      lookup(entry) || raise(MissingEntryError, "missing entry: #{entry}")
    end
  end
end
