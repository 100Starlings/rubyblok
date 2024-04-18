require "spec_helper"

RSpec.describe Rubyblok::Generators::HelloWorldGenerator do
  include GeneratorSpec::TestCase

  # let(:space_id) { rand(1...99_999) }

  tests(described_class)
  destination(File.join(Dir.tmpdir, "files"))

  before { prepare_destination }

  context "when executing the hello world generator" do
    before do
      FileUtils.mkdir_p(File.join(destination_root, "config"))
      File.write(File.join(destination_root, "config/routes.rb"), "Rails.application.routes.draw do\nend\n")

      allow(Rubyblok.configuration).to(receive_messages(model_name: "Page", component_path: "shared/storyblok"))
    end

    it "should create the partial file and storyblok component and story" do
      run_generator

      assert_file("app/controllers/pages_controller.rb")
      assert_file("app/views/pages/index.html.erb")
      assert_file("app/views/shared/storyblok/_feature.html.erb")
      assert_file("app/views/shared/storyblok/_page.html.erb")
      assert_file("app/views/shared/storyblok/_grid.html.erb")
      assert_file("app/views/shared/storyblok/_teaser.html.erb")
      assert_file("app/assets/stylesheets/hello.css")
    end
  end
end
