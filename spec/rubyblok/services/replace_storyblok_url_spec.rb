# frozen_string_literal: true

require 'spec_helper'

describe Rubyblok::Services::ReplaceStoryblokUrl do
  describe '.call' do
    subject(:replace_url) { described_class.call(story:) }

    let(:story) { JSON.parse(File.read('spec/support/home.json')) }
    let(:image_url) { 'https://a.storyblok.com/f/236225/798x465/62c0bc474f/rubyblokxyodel.jpg' }

    context 'when use_cdn_images is enabled' do
      let(:use_cdn_images) { true }

      before do
        allow(Rubyblok.configuration).to receive_messages(use_cdn_images:, image_model_name: 'StoryblokImage')
        image = double(url: 'url') # rubocop:disable RSpec/VerifiedDoubles
        allow_any_instance_of(StoryblokImage).to receive_messages(image:) # rubocop:disable RSpec/AnyInstance
      end

      context 'when the image already exists' do
        before do
          StoryblokImage.create(original_image_url: image_url)
        end

        it 'replaces the url in the content' do
          expect(replace_url['content'].to_dot.body.second.image.filename).to eq('url')
        end

        it 'does create new image record' do
          expect { replace_url }.not_to change { StoryblokImage.all.count }.from(1)
        end
      end

      context 'when the image does not exist' do
        it 'replaces the url in the content' do
          expect(replace_url['content'].to_dot.body.second.image.filename).to eq('url')
        end

        it 'creates the image record' do
          expect { replace_url }.to change { StoryblokImage.where(original_image_url: image_url).count }.to(1)
        end
      end
    end

    context 'when use_cdn_images is disabled' do
      it 'does not replace the url in the content' do
        expect(replace_url).to eq(story)
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
