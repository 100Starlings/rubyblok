# frozen_string_literal: true

module Rubyblok
  module Services
    class ReplaceStoryblokUrl
      attr_reader :story

      def self.call(story:)
        new(story:).call
      end

      def initialize(story:)
        @story = story
      end

      def call
        return story unless use_cdn_images?

        image_fields = find_image_fields(story['content'])
        image_fields.each do |image_field|
          replace_url(image_field)
        end
        story
      end

      private

      # It finds image fields based on their "fieldtype"=>"asset" attribute.
      # Please note that it caches only images added as an 'Asset' field type in Storyblok.
      def find_image_fields(content)
        return [content] if image_field?(content)

        content.values.each_with_object([]) do |field_value, image_fields|
          case field_value
          when Array
            field_value.each { |component| image_fields << find_image_fields(component) }
          when Hash
            image_fields << find_image_fields(field_value)
          end
        end.flatten
      end

      def image_field?(field)
        field['fieldtype'] == 'asset'
      end

      def replace_url(image_field)
        url = image_field['filename']
        image =
          image_model.create_with(remote_image_url: url).find_or_create_by(original_image_url: url)

        image_field['filename'] = image.image.url if image.persisted?
      end

      def image_model
        Rubyblok.configuration.image_model_name.classify.constantize
      end

      def use_cdn_images?
        Rubyblok.configuration.use_cdn_images
      end
    end
  end
end
