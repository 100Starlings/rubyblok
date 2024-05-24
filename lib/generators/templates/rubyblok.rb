# frozen_string_literal: true

Rubyblok.configure do |config|
  config.api_token = ENV["STORYBLOK_API_TOKEN"]
  config.auto_update = ActiveModel::Type::Boolean.new.cast(ENV["STORYBLOK_AUTOUPDATE"])
  config.cached = ActiveModel::Type::Boolean.new.cast(ENV["STORYBLOK_CACHED"])
  config.cdn_images = ActiveModel::Type::Boolean.new.cast(ENV["STORYBLOK_CDN_IMAGES"])
  config.component_path = "shared/storyblok"
  config.model_name = ""
  config.version = ENV["STORYBLOK_VERSION"]
  config.webhook_secret = ENV["STORYBLOK_WEBHOOK_SECRET"]
end
