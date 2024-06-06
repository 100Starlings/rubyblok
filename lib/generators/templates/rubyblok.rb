# frozen_string_literal: true

Rubyblok.configure do |config|
  config.api_token = ENV.fetch('STORYBLOK_API_TOKEN', nil)
  config.auto_update = ActiveModel::Type::Boolean.new.cast(ENV.fetch('STORYBLOK_AUTOUPDATE', nil))
  config.cached = ActiveModel::Type::Boolean.new.cast(ENV.fetch('STORYBLOK_CACHED', nil))
  config.cdn_images = ActiveModel::Type::Boolean.new.cast(ENV['STORYBLOK_CDN_IMAGES'])
  config.component_path = 'shared/storyblok'
  config.model_name = ''
  config.version = ENV.fetch('STORYBLOK_VERSION', nil)
  config.webhook_secret = ENV.fetch('STORYBLOK_WEBHOOK_SECRET', nil)
end
