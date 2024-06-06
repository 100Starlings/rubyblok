# frozen_string_literal: true

require 'active_support/concern'

module Rubyblok
  module Mixins
    module Model
      extend ActiveSupport::Concern

      included do
        validates :storyblok_story_id, presence: true
        validates :storyblok_story_slug, presence: true
        validates :storyblok_story_content, presence: true

        serialize :storyblok_story_content, coder: JSON
      end

      class_methods do
        def fetch_content(slug)
          find_by(storyblok_story_slug: slug)&.storyblok_story_content
        end

        def find_or_create(story)
          return if story.blank?

          find_or_initialize_by(storyblok_story_id: story['id']).tap do |page_object|
            page_object.storyblok_story_content = story
            page_object.storyblok_story_slug = story['full_slug']
            page_object.save
          end
        end
      end
    end
  end
end
