# frozen_string_literal: true

require 'aws-sdk-s3'
require 'httparty'

module Rubyblok
  module Mixins
    module CacheableStoryblokImage
      def with_cached_images(story)
        story.deep_transform_values do |value|
          extract_urls_from(value.to_s).each do |url|
            next if filetype_by(url) != :image

            value = value.gsub(url, upload_image(url))
          end

          value
        end
      end

      private

      def extract_urls_from(text)
        return [text] if /^#{URI::DEFAULT_PARSER.make_regexp}$/.match?(text)

        text.scan(/\[.*\]\((?<url>.*)\)/).flatten
      end

      def filetype_by(file_url)
        MIME::Types.type_for(file_url).first&.media_type&.to_sym
      end

      def upload_image(original_url)
        # TODO: Replace with ENV vars
        bucket_name = 'bucket-name'
        object_key = File.basename(original_url)
        options = { region: 'eu-west-1', access_key_id: '1', secret_access_key: '2' }
        file_path = downloaded_file_path(original_url)
        object = Aws::S3::Object.new(bucket_name, object_key, **options)
        object.upload_file(file_path)
        object.public_url
      end

      def downloaded_file_path(url)
        filename = File.basename(url)
        file_path = Rails.root.join('tmp', filename)
        File.binwrite(file_path, HTTParty.get(url).body)
        return file_path if File.exist?(file_path)

        nil
      end
    end
  end
end
