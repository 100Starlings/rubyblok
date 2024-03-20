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
      end
    end
  end
end
