require "spec_helper"

RSpec.describe PageObject do
  describe ".fetch_content" do
    subject(:fetch_content) { described_class.fetch_content(slug) }

    let(:slug) { "slug" }
    let(:story_id) { 1234 }
    let(:content) { "content" }

    let(:page_object) do
      PageObject.create(
        storyblok_story_id: story_id,
        storyblok_story_slug: slug,
        storyblok_story_content: content
      )
    end

    before { page_object }

    it "returns the page object content" do
      expect(fetch_content).to eq(content)
    end
  end

  describe ".find_or_create" do
    subject(:find_or_create) { described_class.find_or_create(story) }

    let(:story) { JSON.parse(File.read("spec/support/home.json")) }

    before { find_or_create }

    it "creates the page object" do
      expect(PageObject.find_by(storyblok_story_slug: story["full_slug"])).to have_attributes(
        storyblok_story_id: story["id"].to_s,
        storyblok_story_content: be_present
      )
    end
  end
end
