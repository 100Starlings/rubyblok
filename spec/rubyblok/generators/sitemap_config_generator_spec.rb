# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rubyblok::Generators::SitemapConfigGenerator, type: :generator do
  include Rails::Generators::Testing::Assertions

  tests(described_class)
  destination(File.join(Dir.tmpdir, 'files'))

  context 'when executing the sitemap config generator' do
    let(:gemfile_path) { File.join(destination_root, 'Gemfile') }
    let(:setup_gemfile) { File.write(gemfile_path, '') }

    let(:setup) do
      prepare_destination

      allow(Rails).to(receive(:root).and_return(Pathname.new(destination_root)))
      setup_gemfile

      run_generator
    end

    before { setup }

    it 'creates the configuration file' do
      assert_file('config/sitemap.rb') { |content| expect(content).to(match(/SitemapGenerator::Sitemap.create/)) }
    end

    context 'when the sitemap_generator gem is not present in the Gemfile' do
      it 'adds the sitemap_generator gem to the Gemfile' do
        assert_file('Gemfile') { |content| expect(content).to(match(/gem 'sitemap_generator'/)) }
      end
    end

    context 'when the sitemap_generator gem is present in the Gemfile' do
      let(:setup_gemfile) { File.write(gemfile_path, "gem 'sitemap_generator'") }

      it 'adds the sitemap_generator gem to the Gemfile' do
        assert_file('Gemfile') { |content| expect(content).to(eq("gem 'sitemap_generator'")) }
      end
    end
  end
end
