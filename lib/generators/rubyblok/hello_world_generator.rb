require "rails/generators"

module Rubyblok
  module Generators
    class HelloWorldGenerator < Rails::Generators::Base
      argument :space_id, type: :string

      source_root File.expand_path("../templates", __dir__)

      desc 'Generates a "Hello, world" Rubyblok page.'

      def generate_hello_world
        copy_partial

        create_storyblok_component unless storyblok_component_exists?
        create_storyblok_story unless storyblok_story_exists?
      end

      private

      def copy_partial
        template("_hello_world.html.erb", "app/views/#{destination_partial_path}/_hello_world.html.erb")
      end

      def destination_partial_path
        Rubyblok.configuration.component_path
      end

      def create_storyblok_component
        storyblok_client.post("/spaces/#{space_id}/components", storyblok_component_payload)
      end

      def storyblok_component_payload # rubocop:disable Metrics/MethodLength
        {
          component: {
            name: "hello_world",
            display_name: nil,
            schema: {
              content: {
                type: "text",
                pos: 0,
                translatable: true,
                description: "Your first Rubyblok component",
              },
            },
            is_root: false,
            is_nestable: true,
          },
        }
      end

      def storyblok_component_exists?
        storyblok_client.get("/spaces/#{space_id}/components/hello_world")
        true
      rescue RestClient::NotFound
        false
      end

      def create_storyblok_story
        storyblok_client.post("/spaces/#{space_id}/stories", storyblok_story_payload)
      end

      def storyblok_story_payload # rubocop:disable Metrics/MethodLength
        {
          story: {
            name: "hello-world",
            slug: "hello-world",
            content: {
              component: "page",
              page_container: [
                {
                  uuid: SecureRandom.uuid,
                  component: "hello_world",
                  content: "\"Hello, world\" from Rubyblok",
                },
              ],
            },
          },
          publish: 1,
        }
      end

      def storyblok_story_exists?
        Rubyblok::Services::GetStoryblokStory.call(slug: "hello-world")
        true
      rescue RestClient::NotFound
        false
      end

      def storyblok_client
        @storyblok_client ||= Storyblok::Client.new(oauth_token: ENV["STORYBLOK_API_TOKEN_OAUTH"])
      end
    end
  end
end
