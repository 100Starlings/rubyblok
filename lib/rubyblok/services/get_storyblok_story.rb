# frozen_string_literal: true

module Rubyblok
  module Services
    class GetStoryblokStory
      def self.call(slug:)
        new(slug:).call
      end

      def initialize(slug:)
        @slug = slug
      end

      def call
        get_story
      end

      private

      def storyblok_client
        Storyblok::Client.new(
          token: Rubyblok.configuration.api_token,
          version: Rubyblok.configuration.version
        )
      end

      def get_story # rubocop:disable Naming/AccessorMethodName
        storyblok_client.story(@slug)['data']['story']
      end
    end
  end
end
