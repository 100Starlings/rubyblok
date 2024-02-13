require "spec_helper"

describe GetStoryblokStory do
  describe ".call" do
    context "with valid story ID" do
      let(:story_id) { "valid_story_id" }
      let(:story_data) { { "title" => "Test Story" } }
      let(:api_token) { "api_token" }

      before do
        allow(Rubyblok.configuration).to receive(:api_token).and_return(api_token)
        stub_request(:get, /api.storyblok.com/).
         to_return(body: { "story" => story_data }.to_json)

      end

      it "returns the story data" do
        expect(GetStoryblokStory.call(story_id: story_id)).to eq(story_data)
      end
    end
  end
end
