# frozen_string_literal: true

require_relative "lib/concuss/version"

Gem::Specification.new do |spec|
  spec.name = "concuss"
  spec.version = Concuss::VERSION
  spec.authors = ["Patrick Tulskie"]
  spec.email = ["patricktulskie@gmail.com"]

  spec.summary = "Automatic testing for malformed header vulns"
  spec.description = "Test websites for header injection issues"
  spec.homepage = "https://github.com/patricktulskie/concuss"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/PatrickTulskie/concuss"
  spec.metadata["changelog_uri"] = "https://github.com/PatrickTulskie/concuss/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:script|test|spec|features|vuln_app)/|\.(?:git|circleci)|appveyor|Dockerfile|docker-compose.yml)})
    end
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
end
