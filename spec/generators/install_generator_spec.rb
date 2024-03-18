require "spec_helper"

RSpec.describe Rubyblok::Generators::InstallGenerator do
  include GeneratorSpec::TestCase

  tests(described_class)
  destination(File.join(Dir.tmpdir, "files"))

  before do
    stub_const("STORYBLOK_API_TOKEN", "token")
    prepare_destination
  end

  context "when executing the install generator" do
    context "when the file doesn't exist" do
      before do
        run_generator
      end

      it "should create the initializer file with the right content" do
        assert_file("config/initializers/rubyblok.rb")
        assert_file("config/initializers/rubyblok.rb") do |content|
          expect(content).to match(/token/)
        end
      end
    end
  end
end
