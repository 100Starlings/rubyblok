require "spec_helper"

describe GetStoryblokStory do
  describe ".call" do
    context "with valid story ID" do
      let(:slug) { "valid_story_id" }
      let(:api_token) { "api_token" }
      let(:story_data) do
        {
          "name" => "Home",
          "created_at" => "2023-06-15T15=>06=>02.647Z",
          "published_at" => "2024-02-12T14=>52=>41.474Z",
          "content" => {
            "keywords" => "ruby gem",
            "title" => "homepage",
            "no_index" => true,
            "component" => "page",
            "meta_title" => "Rubyblok",
            "default_footer" => false,
            "default_header" => true,
            "default_layout" => false,
            "page_container" => [],
            "_editable" => "editable",
          },
          "schema" => "page",
        }
      end

      before do
        allow(Rubyblok.configuration).to receive(:api_token).and_return(api_token)
        stub_request(:get, /api.storyblok.com/).
         to_return(body: { "story" => story_data }.to_json)
      end

      it "returns the story data" do
        expect(GetStoryblokStory.call(slug:)).to eq(story_data)
      end
    end
  end
end
