# frozen_string_literal: true

require_relative 'lib/rubyblok/version'

Gem::Specification.new do |spec|
  spec.name = 'rubyblok'
  spec.version = Rubyblok::VERSION
  spec.license = 'MIT'
  spec.authors = ['100 Starlings']
  spec.email = ['rubyblok@100starlings.com']

  spec.summary = 'Simple Storyblok CMS integration for Rails'
  spec.homepage = 'http://www.rubyblok.com'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/100Starlings/rubyblok'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency "aws-sdk-s3", "~> 1.151.0"
  spec.add_dependency 'hash_dot', '~> 2.5'
  spec.add_dependency "httparty", "~> 0.22.0"
  spec.add_dependency 'railties', '~> 7.1'
  spec.add_dependency 'redcarpet', '~> 3.6.0'
  spec.add_dependency 'storyblok', '~> 3.2.0'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
