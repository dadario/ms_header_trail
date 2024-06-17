# frozen_string_literal: true

require_relative "lib/ms_header_trail/version"

Gem::Specification.new do |spec|
  spec.name = "ms_header_trail"
  spec.version = MsHeaderTrail::VERSION
  spec.authors = ["Adriano Dadario"]
  spec.email = ["dadario@gmail.com"]

  spec.summary = "Transport collected data through HTTP header from microservices requests."
  spec.homepage = "https://github.com/dadario/ms_header_trail"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dadario/ms_header_trail"
  spec.metadata["changelog_uri"] = "https://github.com/dadario/ms_header_trail/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "faraday"
end
