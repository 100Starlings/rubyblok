# frozen_string_literal: true

require 'spec_helper'

describe 'CacheableStoryblokImage' do
  subject(:object) do
    klass = Class.new { include Rubyblok::Mixins::CacheableStoryblokImage }
    klass.new
  end

  let(:storyblok_story) { JSON.parse(File.read('spec/support/home.json')) }

  before do
    FileUtils.mkdir_p(Pathname.new(Dir.tmpdir).join('tmp'))

    allow(Rails).to(receive(:root).and_return(Pathname.new(Dir.tmpdir)))

    stub_request(:get, %r{a.storyblok.com/f/.*/duck.jpg}).to_return(status: 200, body: 'content')
    stub_request(:put, %r{/duck.jpg}).to_return(status: 200)
  end

  it do
    storyblok_story_with_cached_images = object.with_cached_images(storyblok_story)
    expect(storyblok_story_with_cached_images.to_json).to(match(%r{amazonaws.com/duck.jpg}))
  end
end
