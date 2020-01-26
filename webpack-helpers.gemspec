# frozen_string_literal: true

require_relative "lib/webpack/helpers/version"

Gem::Specification.new do |spec|
  spec.name          = "webpack-helpers"
  spec.version       = Webpack::Helpers::VERSION
  spec.authors       = ["ak10m"]
  spec.email         = ["akio.morimoto@airits.jp"]

  spec.summary       = "Make Ruby and Webpack as loosely coupled as possible."
  spec.description   = "Make Ruby and Webpack as loosely coupled as possible."
  spec.homepage      = "https://github.com/ak10m/webpack-helpers"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "#{spec.homepage}/tree/#{spec.version}"
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/#{spec.version}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rack-proxy"

  spec.add_development_dependency "bundler", "~> 2.1.3"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rubocop", "~> 0.78.0"
  spec.add_development_dependency "rubocop-minitest", "~> 0.5.1"
  spec.add_development_dependency "rubocop-performance", "~> 1.5.2"
end
