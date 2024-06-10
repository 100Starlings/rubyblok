# frozen_string_literal: true

require 'active_support/concern'

module Rubyblok
  module Mixins
    module Webhook
      extend ActiveSupport::Concern

      included do
        skip_before_action :verify_authenticity_token, only: [:create]

        def create
          payload = JSON.parse(request.raw_post)

          storyblok_story = Rubyblok::Services::GetStoryblokStory.call(slug: payload['story_id'])
          storyblok_story = Rubyblok::Services::ReplaceStoryblokUrl.call(story: storyblok_story)
          model.find_or_create(storyblok_story)

          render(json: { success: true })
        end

        private

        def model
          Rubyblok.configuration.model_name.classify.constantize
        end
      end
    end
  end
end
