# frozen_string_literal: true

require "spec_helper"

RSpec.describe StoryblokHelper do
  let!(:storyblok_helper) { Object.new.extend(StoryblokHelper) }

  let(:api_token)      { "api_token" }
  let(:version)        { "version" }
  let(:component_path) { "shared" }

  let(:richtext_content) do
    { "type" => "doc",
      "content" => [
        { "type" => "paragraph",
          "content" =>
            [{ "text" => "this is a richtext",
               "type" => "text" }] },
      ] }.to_dot
  end

  before do
    allow(Rubyblok.configuration).to receive_messages(api_token:, version:,
                                                      component_path:)
  end

  describe "#rubyblok_content_tag" do
    let(:content) { "" }

    context "when the content is blank" do
      it "returns the right view" do
        result = storyblok_helper.rubyblok_content_tag(content)

        expect(result).to be_nil
      end
    end

    context "when the content is a string" do
      let(:content) { "string" }

      it "returns the right view" do
        result = storyblok_helper.rubyblok_content_tag(content)
        expect(result.squish).to eq("<p>string</p>")
      end
    end

    context "when the content is a markdown" do
      let(:content) { "this is a **mark** down" }

      it "returns the right view" do
        result = storyblok_helper.rubyblok_content_tag(content)
        expect(result.squish).to eq("<p>this is a <strong>mark</strong> down</p>")
      end
    end

    context "when the content is a richtext" do
      it "returns the right view" do
        result = storyblok_helper.rubyblok_content_tag(richtext_content)

        expect(result.squish).to eq("<p>this is a richtext</p>")
      end
    end
  end

  describe "#rubyblok_component_tag" do
    context "when is a simple component" do
      let(:editable) { "<!--#storyblok\#{\"name\": \"editable_name\"}-->" }

      let(:component_object) do
        {
          "component" => "page",
          "title" => "homepage",
          "_editable" => editable,
        }.to_dot
      end

      it "render the right partial" do
        result = storyblok_helper.rubyblok_component_tag(blok: component_object)

        expect(result.squish).to eq("<!--#storyblok\#{\"name\": \"editable_name\"}--><head> homepage </head>")
      end
    end

    context "when the component is nested" do
      let(:component_object) do
        {
          "component" => "nested_page",
          "page_container" => [
            { "component" => "button", "title" => "button1" },
            { "component" => "button", "title" => "button2" },
          ],
        }.to_dot
      end

      it "render the right partial" do
        result = storyblok_helper.rubyblok_component_tag(blok: component_object)

        expect(result.squish).to eq("<div> <a> button1 </a> <a> button2 </a> </div>")
      end
    end

    context "when the partial is present" do
      let(:partial) { "section" }

      let(:component_object) do
        { "component" => "page",
          "text" => "hello"
           }.to_dot
      end

      it "render the right partial" do
        result = storyblok_helper.rubyblok_component_tag(blok: component_object, partial:)

        expect(result.squish).to eq("<aside> hello </aside>")
      end
    end

    context "when the _editable is not present" do
      let(:component_object) do
        { "component" => "page",
          "title" => "homepage",
          "_editable" => "" }.to_dot
      end

      it "render the right partial" do
        result = storyblok_helper.rubyblok_component_tag(blok: component_object)

        expect(result.squish).to eq("<head> homepage </head>")
      end
    end
  end

  describe "#rubyblok_markdown_tag" do
    context "when the content is a string" do
      let(:content) { "string" }

      it "returns the right view" do
        result = storyblok_helper.rubyblok_markdown_tag(content)
        expect(result.squish).to eq("<p>string</p>")
      end
    end

    context "when the content is a markdown" do
      let(:content) { "this is a **mark** down" }

      it "returns the right view" do
        result = storyblok_helper.rubyblok_markdown_tag(content)
        expect(result.squish).to eq("<p>this is a <strong>mark</strong> down</p>")
      end
    end

    context "when the content is a text area" do
      let(:content) { "this is a\ntext area\n" }

      it "returns the right view" do
        result = storyblok_helper.rubyblok_markdown_tag(content)
        expect(result.squish).to eq("<p>this is a text area</p>")
      end
    end
  end

  describe "#rubyblok_richtext_tag" do
    context "when the content is a simple richtext" do
      it "returns the right view" do
        result = storyblok_helper.rubyblok_richtext_tag(richtext_content)

        expect(result.squish).to eq("<p>this is a richtext</p>")
      end
    end

    context "when the richtext contains a component" do
      let(:content) do
        { "type" => "doc",
        "content" =>
         [{ "type" => "blok",
           "attrs" =>
            { "body" =>
              [{ "type" => "",
                "title" => "richtext",
                "component" => "button",
                "button_link" => "" }] } },
          { "type" => "paragraph", "content" => [{ "text" => "Richtext test", "type" => "text" }] }] }.to_dot
      end

      it "returns the right view" do
        result = storyblok_helper.rubyblok_richtext_tag(content)

        expect(result.squish).to eq("<a> richtext </a> <p>Richtext test</p>")
      end
    end
  end

  describe "#rubyblok_story_tag" do
    let(:slug) { "Home" }
    let(:story_data) do
      {
        "name" => "Home",
        "content" => {
          "title" => "homepage",
          "component" => "page"
        },
        "schema" => "page",
      }.to_dot
    end

    before do
      allow(GetStoryblokStory).to receive(:call).and_return(story_data)
    end

    it "returns the right view" do
      result = storyblok_helper.rubyblok_story_tag(slug)
      expect(result.squish).to eq("<head> homepage </head>")
    end
  end

  describe "#rubyblok_blocks_tag" do
    let(:component_object) do
      {
        "component" => "hero_section",
        "cta_buttons" => [
          {
            "title" => "Try for free",
            "component" => "button"
          },
          {
            "title" => "Discover more",
            "component" => "button"
          },
        ]
      }.to_dot
    end

    it "returns the right view" do
      result = storyblok_helper.rubyblok_blocks_tag(component_object.cta_buttons)
      expect(result.squish).to eq("<a> Try for free </a> <a> Discover more </a>")
    end
  end
end
