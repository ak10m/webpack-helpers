# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

begin
  require "rails"
rescue StandardError
  puts "rails is not installed"
end
