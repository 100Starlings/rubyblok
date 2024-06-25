# frozen_string_literal: true

require 'spec_helper'
require 'rake'

describe 'rubyblok:create_or_update_content' do # rubocop:disable RSpec/DescribeClass
  before do
    Rake.application.rake_require 'tasks/rubyblok/create_or_update_content'
    Rake::Task.define_task(:environment)

    allow(Rubyblok.configuration).to(receive_messages(api_token: :token, version: 'draft', model_name: 'PageObject'))

    stub_request(:get, %r{api.storyblok.com/v2/cdn/stories})
      .to_return({ status: 200, body: first_storyblok_request_body },
                 { status: 200, body: second_storyblok_request_body })

    PageObject.create(storyblok_story_id: 1, storyblok_story_slug: 'existent',
                      storyblok_story_content: 'Outdated content')
  end

  let(:first_storyblok_request_body) do
    { stories: [{ id: 1, full_slug: :existing }, { id: 2, full_slug: :inexisting }] }.to_json
  end

  let(:second_storyblok_request_body) { { stories: [] }.to_json }

  context 'when invoking the task' do
    before { Rake::Task['rubyblok:create_or_update_content'].invoke }

    let(:expected) do
      [
        {
          'storyblok_story_id' => '1',
          'storyblok_story_content' => { 'id' => 1, 'full_slug' => 'existing' },
          'storyblok_story_slug' => 'existing'
        },
        {
          'storyblok_story_id' => '2',
          'storyblok_story_content' => { 'id' => 2, 'full_slug' => 'inexisting' },
          'storyblok_story_slug' => 'inexisting'
        }
      ]
    end

    it 'creates a new record and updates an existing one' do
      expect(PageObject.all.as_json(only: %i[storyblok_story_id storyblok_story_slug storyblok_story_content])).to(
        match_array(expected)
      )
    end
  end
end
