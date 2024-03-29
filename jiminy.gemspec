# frozen_string_literal: true

require_relative "lib/jiminy/version"

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name          = "jiminy"
  spec.version       = Jiminy::VERSION
  spec.authors       = ["Bodacious"]
  spec.email         = ["gavin@gavinmorrice.com"]
  spec.license       = "MIT"
  spec.summary       = "Detects N+1 queries in test suite and comments on Github PRs"
  spec.description   = <<~STRING
    Wraps around your CI integration to detect and warn about n+1 queries before they're merged
  STRING
  spec.homepage = "https://github.com/bodacious/jiminy"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = File.join(spec.homepage, "blob/main/CHANGELOG.md")

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:spec)/|\.(?:git|circleci))})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "octokit", ">= 4"
  spec.add_runtime_dependency "prosopite", ">= 1"
  spec.add_runtime_dependency "rspec"
  spec.add_runtime_dependency "thor", ">= 1.2"
  spec.metadata["rubygems_mfa_required"] = "true"
end
# rubocop:enable Metrics/BlockLength
