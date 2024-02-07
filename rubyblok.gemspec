# frozen_string_literal: true

require_relative "lib/rubyblok/version"

Gem::Specification.new do |spec|
  spec.name = "rubyblok"
  spec.version = Rubyblok::VERSION
  spec.authors = ["100 Starlings"]
  spec.email = ["info@100starlings.com"]

  spec.summary = "This is a brief"
  spec.homepage = "http://www.rubyblok.com"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubyblok.com"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/100Starlings/rubyblok-website"
  spec.metadata["changelog_uri"] = "https://github.com/100Starlings/rubyblok-website"

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
