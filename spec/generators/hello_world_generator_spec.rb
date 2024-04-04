require "spec_helper"

RSpec.describe Rubyblok::Generators::HelloWorldGenerator do
  include GeneratorSpec::TestCase

  let(:space_id) { rand(1...99_999) }

  tests(described_class)
  destination(File.join(Dir.tmpdir, "files"))

  before { prepare_destination }

  context "when executing the hello world generator" do
    before do
      stub_const("ENV", { "STORYBLOK_API_TOKEN" => "token", "STORYBLOK_API_TOKEN_OAUTH" => "token" })

      allow(Rubyblok.configuration)
        .to(receive_messages(api_token: "API token", version: "version", component_path: "shared/storyblok"))

      stub_request(:get, %r{api.storyblok.com/v1/spaces/#{space_id}/components/hello_world})
        .to_return(status: 404)
      stub_request(:get, %r{api.storyblok.com/v2/cdn/stories/hello-world})
        .to_return(status: 404)
    end

    it "should create the partial file and storyblok component and story" do
      expect_any_instance_of(Storyblok::Client).to(receive(:post).twice)

      run_generator([space_id])

      assert_file("app/views/shared/storyblok/_hello_world.html.erb")
    end
  end
end
