require "spec_helper"
# rubocop:disable Lint/EmptyClass:
class Page; end
# rubocop:enable Lint/EmptyClass:

# rubocop:disable RSpec/SubjectStub
RSpec.describe WebhookController do
  subject(:webhook_controller) { described_class.new }

  let(:api_token) { "api_token" }
  let(:version) { "version" }
  let(:component_path) { "shared" }
  let(:webhook_secret) { "webhook_secret" }
  let(:model_name) { "Page" }
  let(:page) { Page.new }
  let(:params) do
    { "text" => "text",
      "action" => "publish",
      "space_id" => 123,
      "story_id" => 456,
      "name" => "home",
      "full_slug" => "home" }
  end

  before do
    allow(webhook_controller.request).to receive(:raw_post).and_return(params.to_json)
    allow(Rubyblok.configuration).to receive_messages(
      api_token:,
      version:,
      component_path:,
      webhook_secret:,
      model_name:
    )

    allow(Rubyblok::Services::GetStoryblokStory).to receive(:call).and_return(params)
    allow(Page).to receive(:find_or_initialize_by).and_return(page)
  end

  context "when the webhook receives an update" do
    it "renders the correct response" do
      allow(page).to receive(:update)
      expect(webhook_controller).to receive(:render).with(json: { success: true })
      webhook_controller.create
    end

    it "the model should receive the right params" do
      allow(webhook_controller).to receive(:render)
      expect(page).to receive(:update).with(storyblok_story_content: params, storyblok_story_slug: "home")
      webhook_controller.create
    end
  end
end
# rubocop:enable RSpec/SubjectStub
