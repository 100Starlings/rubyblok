# frozen_string_literal: true

require_relative "lib/rubyblok/version"

Gem::Specification.new do |spec|
  spec.name = "rubyblok"
  spec.version = Rubyblok::VERSION
  spec.authors = ["100 Starlings"]
  spec.email = ["info@100starlings.com"]

  spec.summary = "TODO: Write a short summary, because RubyGems requires one."
  spec.homepage = "www.rubyblok.com"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubyblok.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec"
  spec.add_dependency "rails"
  spec.add_dependency "pg"
  spec.add_dependency "dotenv-rails"
  spec.add_dependency "tailwindcss-rails"
  spec.add_dependency "thor"
end
