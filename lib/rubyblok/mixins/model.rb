module Rubyblok
  module Mixins
    module Model
      extend ActiveSupport::Concern

      included do
        validates :storyblok_story_id, presence: true
        validates :storyblok_story_slug, presence: true
        validates :storyblok_story_content, presence: true
      end
    end
  end
end
