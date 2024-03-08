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

    context "when the application already has the file" do

      before do
        run_generator
      end

      it "should skip creating the initializer" do
        output = run_generator
        expect(output).to include("identical  config/initializers/rubyblok.rb")
      end
    end

    context "when the application already has a file with different content" do
      before(:each) do
        FileUtils.mkdir_p(File.join(destination_root, "config/initializers"))
        File.write(File.join(destination_root, "config/initializers/rubyblok.rb"), "class")
      end

      it "should ask if the user wants to overwrite" do
        output = run_generator
        expect(output).to include("conflict  config/initializers/rubyblok.rb")
      end
    end
  end
end
