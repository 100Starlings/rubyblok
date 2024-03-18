require "spec_helper"

RSpec.describe Rubyblok::Mixins::Webhook, type: :controller do
  describe "#create" do
    let(:subject) { Class.new { include Rubyblok::Mixins::Webhook } } # rubocop:disable RSpec/SubjectDeclaration
    let(:instance) { subject.new }

    let(:api_token)      { "api_token" }
    let(:version)        { "version" }
    let(:component_path) { "shared" }
    let(:webhook_secret) { "webhook_secret" }
    let(:params) { { text: "text", action: "publish", space_id: 123, story_id: 456 }.to_json }

    before do
      allow(instance).to receive(:render).with(json: { success: true }).and_return({ success: true })
      allow(Rubyblok.configuration).to receive_messages(api_token:,
                                                        version:,
                                                        component_path:,
                                                        webhook_secret:)
    end

    context "when the webhook receives an update" do
      it "renders the correct response" do
        expect(instance).to respond_to(:create)
        expect(instance.create).to eq({ success: true })
      end
    end
  end
end
