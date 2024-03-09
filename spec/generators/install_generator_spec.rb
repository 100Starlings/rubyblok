require "spec_helper"

RSpec.describe Rubyblok::Generators::InstallGenerator do
  include GeneratorSpec::TestCase

  tests(described_class)
  destination(File.join(Dir.tmpdir, "files"))

  before(:each) do
    prepare_destination
  end

  context "when executing the install generator" do
    context "when the file doesn't exist" do

      before do
        run_generator
      end

      it "should create the initializer file" do
        assert_file("config/initializers/rubyblok.rb")
      end
    end
  end
end
