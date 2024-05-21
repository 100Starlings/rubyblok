# frozen_string_literal: true

Rubyblok.configure do |config|
  config.cached         = true

  config.api_token      = ENV["STORYBLOK_API_TOKEN"]
  config.version        = ENV["STORYBLOK_VERSION"]
  config.webhook_secret = ENV["STORYBLOK_WEBHOOK_SECRET"]

  config.model_name     = ""
  config.component_path = "shared/storyblok"
end
