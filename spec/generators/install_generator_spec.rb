require "spec_helper"

RSpec.describe Rubyblok::Generators::InstallGenerator do
  include Rails::Generators::Testing::Assertions
  include Rails::Generators::Testing::Behavior

  tests(described_class)
  destination(File.join(Dir.tmpdir, "files"))

  before do
    prepare_destination
    run_generator
  end

  context "when running the install generator" do
    it "creates the initializer" do
      assert_initializer("rubyblok.rb")
    end
  end
end
