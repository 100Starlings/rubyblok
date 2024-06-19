# frozen_string_literal: true

require 'active_support/concern'

module Rubyblok
  module Mixins
    module Webhook
      extend ActiveSupport::Concern

      included do # rubocop:disable Metrics/BlockLength
        skip_before_action :verify_authenticity_token, only: [:create]

        def create
          verify_signature(request.raw_post) if webhook_secret.present?

          payload = JSON.parse(request.raw_post)
          case payload['action']
          when 'published'
            update_story(payload)
          when 'unpublished', 'deleted'
            model.find_by(storyblok_story_id: payload['story_id'])&.destroy!
          end

          render(json: { success: true })
        end

        private

        def model
          Rubyblok.configuration.model_name.classify.constantize
        end

        def update_story(payload)
          storyblok_story = Rubyblok::Services::GetStoryblokStory.call(slug: payload['story_id'])
          storyblok_story = Rubyblok::Services::ReplaceStoryblokUrl.call(story: storyblok_story)
          model.find_or_create(storyblok_story)
        end

        def verify_signature(payload_body)
          signature =
            OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), webhook_secret, payload_body)
          raise StandardError, 'Signature check failed!' unless verified?(signature)
        end

        def verified?(signature)
          Rack::Utils.secure_compare(signature, request.env['HTTP_WEBHOOK_SIGNATURE'])
        end

        def webhook_secret
          Rubyblok.configuration.webhook_secret
        end
      end
    end
  end
end
