require "spec_helper"

RSpec.describe Rubyblok::Generators::HelloWorldGenerator do
  include GeneratorSpec::TestCase

  let(:name) { "page_object" }
  let(:plural_name) { name.pluralize }

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
      run_generator([name])

      assert_file("app/controllers/#{plural_name}_controller.rb")
      assert_file("app/views/#{plural_name}/index.html.erb")
      assert_file("app/views/shared/storyblok/_feature.html.erb")
      assert_file("app/views/shared/storyblok/_page.html.erb")
      assert_file("app/views/shared/storyblok/_grid.html.erb")
      assert_file("app/views/shared/storyblok/_teaser.html.erb")
      assert_file("app/assets/stylesheets/hello.css")
    end
  end
end
