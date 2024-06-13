# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Webhook' do
  let(:webhook_controller) { WebhookController.new }

  let(:params) do
    { 'text' => 'text', 'action' => 'publish', 'space_id' => 123, 'story_id' => 456, 'name' => 'home',
      'full_slug' => 'home' }
  end

  before do
    allow(webhook_controller.request).to receive(:raw_post).and_return(params.to_json)
    allow(Rubyblok.configuration).to receive_messages(model_name: 'PageObject')
    allow(Rubyblok::Services::GetStoryblokStory).to receive(:call).and_return(params)
  end

  # rubocop:disable RSpec/MessageSpies
  context 'when the webhook receives an update' do
    it 'renders the correct response' do
      expect(webhook_controller).to(receive(:render).with(json: { success: true }))
      webhook_controller.create
    end
  end
  # rubocop:enable RSpec/MessageSpies
end
