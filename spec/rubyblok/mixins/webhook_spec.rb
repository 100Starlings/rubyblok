# frozen_string_literal: true

require 'spec_helper'

class Page
  def self.find_or_initialize_by(**_params)
    new
  end

  def update(**_params)
    true
  end
end

RSpec.describe 'Webhook' do
  let(:webhook_controller) { WebhookController.new }
  let(:page) { Page.new }

  let(:params) do
    { 'text' => 'text', 'action' => 'publish', 'space_id' => 123, 'story_id' => 456, 'name' => 'home',
      'full_slug' => 'home' }
  end

  before do
    allow(webhook_controller.request).to receive(:raw_post).and_return(params.to_json)
    allow(Rubyblok.configuration).to receive_messages(model_name: 'Page')
    allow(Page).to(receive(:new).and_return(page))
    allow(Rubyblok::Services::GetStoryblokStory).to receive(:call).and_return(params)
  end

  # rubocop:disable RSpec/MessageSpies
  context 'when the webhook receives an update' do
    it 'renders the correct response' do
      allow(page).to receive(:update)
      expect(webhook_controller).to(receive(:render).with(json: { success: true }))
      webhook_controller.create
    end

    it 'the model should receive the right params' do
      allow(webhook_controller).to receive(:render)
      expect(page).to(receive(:update).with(storyblok_story_content: params, storyblok_story_slug: 'home'))
      webhook_controller.create
    end
  end
  # rubocop:enable RSpec/MessageSpies
end
