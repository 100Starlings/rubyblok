# frozen_string_literal: true

Rubyblok.configure do |config|
  config.auto_update = ActiveModel::Type::Boolean.new.cast(ENV["STORYBLOK_AUTOUPDATE"])
  config.cached = ActiveModel::Type::Boolean.new.cast(ENV["STORYBLOK_CACHED"])

  config.api_token = ENV["STORYBLOK_API_TOKEN"]
  config.version = ENV["STORYBLOK_VERSION"]
  config.webhook_secret = ENV["STORYBLOK_WEBHOOK_SECRET"]

  config.model_name = ""
  config.component_path = "shared/storyblok"
end
