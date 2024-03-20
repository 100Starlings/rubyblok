module Rubyblok
  module Mixins
    module Webhook
      extend ActiveSupport::Concern

      included do
        skip_before_action :verify_authenticity_token, only: [:create]

        def create
          payload = JSON.parse(request.raw_post)

          storyblok_story_content = Rubyblok::Services::GetStoryblokStory.call(slug: payload["story_id"])
          model.find_or_initialize_by(storyblok_story_id: payload["story_id"])
               .update(storyblok_story_content:, storyblok_story_slug: storyblok_story_content["full_slug"])

          render json: { success: true }
        end

        private

        def model
          Rubyblok.configuration.model_name.classify.constantize
        end
      end
    end
  end
end
