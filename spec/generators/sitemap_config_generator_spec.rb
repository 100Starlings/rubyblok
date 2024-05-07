require "spec_helper"

RSpec.describe Rubyblok::Generators::SitemapConfigGenerator, type: :generator do
  include Rails::Generators::Testing::Assertions

  tests(described_class)
  destination(File.join(Dir.tmpdir, "files"))

  before do
    prepare_destination
    File.write(File.join(destination_root, "Gemfile"), "")

    run_generator
  end

  context "when executing the sitemap config generator" do
    it "creates the configuration file" do
      assert_file("config/sitemap.rb") { |content| expect(content).to(match(/SitemapGenerator::Sitemap.create/)) }
    end

    it "adds the sitemap_generator gem to the Gemfile" do
      assert_file("Gemfile") { |content| expect(content).to(match(/gem 'sitemap_generator'/)) }
    end
  end
end
