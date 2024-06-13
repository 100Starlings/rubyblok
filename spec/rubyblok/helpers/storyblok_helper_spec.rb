# frozen_string_literal: true

require 'spec_helper'

RSpec.describe StoryblokHelper do
  let!(:storyblok_helper) { Object.new.extend(described_class) }

  let(:cached) { false }
  let(:auto_update) { false }

  let(:richtext_content) do
    { 'type' => 'doc',
      'content' => [
        { 'type' => 'paragraph',
          'content' =>
            [{ 'text' => 'this is a richtext',
               'type' => 'text' }] }
      ] }.to_dot
  end

  before do
    allow(Rubyblok.configuration).to receive_messages(
      component_path: 'shared',
      model_name: 'PageObject',
      cached:,
      auto_update:
    )
  end

  describe '#rubyblok_content_tag' do
    let(:content) { '' }

    context 'when the content is blank' do
      it 'returns the right view' do
        result = storyblok_helper.rubyblok_content_tag(content)

        expect(result).to be_nil
      end
    end

    context 'when the content is a string' do
      let(:content) { 'string' }

      it 'returns the right view' do
        result = storyblok_helper.rubyblok_content_tag(content)
        expect(result.squish).to eq('<p>string</p>')
      end
    end

    context 'when the content is a markdown' do
      let(:content) { 'this is a **mark** down' }

      it 'returns the right view' do
        result = storyblok_helper.rubyblok_content_tag(content)
        expect(result.squish).to eq('<p>this is a <strong>mark</strong> down</p>')
      end
    end

    context 'when the content is a richtext' do
      it 'returns the right view' do
        result = storyblok_helper.rubyblok_content_tag(richtext_content)

        expect(result.squish).to eq('<p>this is a richtext</p>')
      end
    end
  end

  describe '#rubyblok_component_tag' do
    context 'when is a simple component' do
      let(:component_object) do
        {
          'component' => 'page',
          'title' => 'homepage',
          '_editable' => "<!--#storyblok\#{\"name\": \"editable_name\"}-->"
        }.to_dot
      end

      it 'render the right partial' do
        result = storyblok_helper.rubyblok_component_tag(blok: component_object)

        expect(result.squish).to eq("<!--#storyblok\#{\"name\": \"editable_name\"}--><head> homepage </head>")
      end
    end

    context 'when the component is nested' do
      let(:component_object) do
        {
          'component' => 'nested_page',
          'page_container' => [
            { 'component' => 'button', 'title' => 'button1' },
            { 'component' => 'button', 'title' => 'button2' }
          ]
        }.to_dot
      end

      it 'render the right partial' do
        result = storyblok_helper.rubyblok_component_tag(blok: component_object)

        expect(result.squish).to eq('<div> <a> button1 </a> <a> button2 </a> </div>')
      end
    end

    context 'when the partial is present' do
      let(:component_object) do
        { 'component' => 'page',
          'text' => 'hello' }.to_dot
      end

      it 'render the right partial' do
        result = storyblok_helper.rubyblok_component_tag(blok: component_object, partial: 'section')

        expect(result.squish).to eq('<aside> hello </aside>')
      end
    end

    context 'when the _editable is not present' do
      let(:component_object) do
        { 'component' => 'page',
          'title' => 'homepage',
          '_editable' => '' }.to_dot
      end

      it 'render the right partial' do
        result = storyblok_helper.rubyblok_component_tag(blok: component_object)

        expect(result.squish).to eq('<head> homepage </head>')
      end
    end
  end

  describe '#rubyblok_markdown_tag' do
    context 'when the content is a string' do
      let(:content) { 'string' }

      it 'returns the right view' do
        result = storyblok_helper.rubyblok_markdown_tag(content)
        expect(result.squish).to eq('<p>string</p>')
      end
    end

    context 'when the content is a markdown' do
      let(:content) { 'this is a **mark** down' }

      it 'returns the right view' do
        result = storyblok_helper.rubyblok_markdown_tag(content)
        expect(result.squish).to eq('<p>this is a <strong>mark</strong> down</p>')
      end
    end

    context 'when the content is a text area' do
      let(:content) { "this is a\ntext area\n" }

      it 'returns the right view' do
        result = storyblok_helper.rubyblok_markdown_tag(content)
        expect(result.squish).to eq('<p>this is a text area</p>')
      end
    end
  end

  describe '#rubyblok_richtext_tag' do
    context 'when the content is a simple richtext' do
      it 'returns the right view' do
        result = storyblok_helper.rubyblok_richtext_tag(richtext_content)

        expect(result.squish).to eq('<p>this is a richtext</p>')
      end
    end

    context 'when the richtext contains a component' do
      let(:content) do
        { 'type' => 'doc',
          'content' =>
         [{ 'type' => 'blok',
            'attrs' =>
            { 'body' =>
              [{ 'type' => '',
                 'title' => 'richtext',
                 'component' => 'button',
                 'button_link' => '' }] } },
          { 'type' => 'paragraph', 'content' => [{ 'text' => 'Richtext test', 'type' => 'text' }] }] }.to_dot
      end

      it 'returns the right view' do
        result = storyblok_helper.rubyblok_richtext_tag(content)

        expect(result.squish).to eq('<a> richtext </a> <p>Richtext test</p>')
      end
    end
  end

  describe '#rubyblok_story_tag' do
    let(:story_data) do
      {
        'name' => 'Home',
        'content' => {
          'title' => 'homepage',
          'component' => 'page'
        },
        'schema' => 'page'
      }
    end

    before do
      allow(Rubyblok.configuration).to receive(:cached).and_return(false)
      allow(Rubyblok::Services::GetStoryblokStory).to receive(:call).and_return(story_data)
    end

    it 'returns the right view' do
      result = storyblok_helper.rubyblok_story_tag('Home')
      expect(result.squish).to eq('<head> homepage </head>')
    end
  end

  describe '#rubyblok_blocks_tag' do
    let(:component_object) do
      {
        'component' => 'hero_section',
        'cta_buttons' => [
          {
            'title' => 'Try for free',
            'component' => 'button'
          },
          {
            'title' => 'Discover more',
            'component' => 'button'
          }
        ]
      }.to_dot
    end

    it 'returns the right view' do
      result = storyblok_helper.rubyblok_blocks_tag(component_object.cta_buttons)
      expect(result.squish).to eq('<a> Try for free </a> <a> Discover more </a>')
    end
  end

  describe '#get_story_content' do # rubocop:disable RSpec/MultipleMemoizedHelpers
    subject(:get_story) { storyblok_helper.get_story_content(slug) }

    let(:slug) { 'Home' }
    let(:story) { JSON.parse(File.read('spec/support/home.json')) }

    before do
      allow(Rubyblok::Services::GetStoryblokStory).to receive(:call).with(slug:).and_return(story)
      allow(storyblok_helper).to receive(:params).and_return({})
    end

    context 'when non cached' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      it 'calls the API' do
        get_story
        expect(Rubyblok::Services::GetStoryblokStory).to have_received(:call).with(slug:)
      end

      it 'returns the content' do
        expect(get_story).to eq(story['content'])
      end

      it 'does not cache the content' do
        get_story
        expect(PageObject.count).to eq(0)
      end
    end

    context 'when cached but not auto update' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:cached) { true }

      before do
        PageObject.create(
          storyblok_story_id: story['id'],
          storyblok_story_slug: slug,
          storyblok_story_content: story
        )
      end

      it 'does not call the API' do
        get_story
        expect(Rubyblok::Services::GetStoryblokStory).not_to have_received(:call).with(slug:)
      end

      it 'returns the content' do
        expect(get_story).to eq(story['content'])
      end
    end

    context 'when cached and auto update' do # rubocop:disable RSpec/MultipleMemoizedHelpers
      let(:cached) { true }
      let(:auto_update) { true }

      it 'calls the API' do
        get_story
        expect(Rubyblok::Services::GetStoryblokStory).to have_received(:call).with(slug:)
      end

      it 'returns the content' do
        expect(get_story).to eq(story['content'])
      end

      it 'creates the page object' do
        get_story
        expect(PageObject.find_by(storyblok_story_slug: story['full_slug'])).to have_attributes(
          storyblok_story_id: story['id'].to_s,
          storyblok_story_content: story
        )
      end
    end
  end
end
