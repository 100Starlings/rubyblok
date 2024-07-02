# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Webhook' do
  let(:webhook_controller) { WebhookController.new }

  describe 'create' do
    subject(:create) { webhook_controller.create }

    let(:story_id) { 456 }
    let(:params) do
      { 'text' => 'text', 'action' => action, 'space_id' => 123, 'story_id' => story_id, 'name' => 'home',
        'full_slug' => 'home' }
    end

    let(:story) { JSON.parse(File.read('spec/support/home.json')) }

    before do
      allow(webhook_controller).to receive(:render)
      allow(webhook_controller.request).to receive(:raw_post).and_return(params.to_json)
      allow(Rubyblok.configuration).to receive_messages(model_name: 'PageObject')
      allow(Rubyblok::Services::GetStoryblokStory).to receive(:call).and_return(story)
    end

    context 'when a story is published' do
      let(:action) { 'published' }

      before { create }

      it 'renders the correct response' do
        expect(webhook_controller).to(have_received(:render).with(json: { success: true }))
      end

      it 'creates page object' do
        expect(PageObject.find_by(storyblok_story_slug: 'home')).to be_present
      end
    end

    context 'when a story is unpublished' do
      let(:action) { 'unpublished' }

      before do
        PageObject.create(
          storyblok_story_id: story_id,
          storyblok_story_slug: 'home',
          storyblok_story_content: story
        )
      end

      it 'renders the correct response' do
        create
        expect(webhook_controller).to(have_received(:render).with(json: { success: true }))
      end

      it 'deletes page object' do
        expect { create }.to change(PageObject, :count).from(1).to(0)
      end
    end

    context 'when the webhook is secured' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:action) { 'published' }
      let(:webhook_secret) { 'secret' }

      before do
        allow(Rubyblok.configuration).to receive_messages(webhook_secret:)
        allow(webhook_controller.request).to receive(:env).and_return(
          'HTTP_WEBHOOK_SIGNATURE' => signature
        )
      end

      context 'with invalid signature' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:signature) { 'invalid' }

        it 'renders the correct response' do
          expect { create }.to raise_error 'Signature check failed!'
        end
      end

      context 'with valid signature' do # rubocop:disable RSpec/MultipleMemoizedHelpers
        let(:signature) do
          OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), webhook_secret, params.to_json)
        end

        it 'renders the correct response' do
          create
          expect(webhook_controller).to(have_received(:render).with(json: { success: true }))
        end
      end
      # rubocop:enable RSpec/NestedGroups
    end
  end
end
