# frozen_string_literal: true

Rubyblok.configure do |config|
  # Storyblok API token
  config.api_token = ENV.fetch('STORYBLOK_API_TOKEN', nil)

  # Storyblok story version (draft or published)
  config.version = ENV.fetch('STORYBLOK_VERSION', 'draft')

  # Name of the model that stores Storyblok stories
  config.model_name = ''

  # Directory contains rubyblok partials (relative to app/views)
  config.component_path = 'shared/storyblok'

  # Feature flag that enables cached mode
  config.cached = ActiveModel::Type::Boolean.new.cast(ENV.fetch('STORYBLOK_CACHED', false))

  # Feature flag that enables auto update of local cache
  config.auto_update = ActiveModel::Type::Boolean.new.cast(ENV.fetch('STORYBLOK_AUTOUPDATE', false))

  # Feature flag that enables caching storyblok images
  config.use_cdn_images = ActiveModel::Type::Boolean.new.cast(ENV.fetch('STORYBLOK_CDN_IMAGES', false))

  # Name of the model that stores Storyblok cached images
  config.image_model_name = ''

  # Storyblok webhook token
  config.webhook_secret = ENV.fetch('STORYBLOK_WEBHOOK_SECRET', nil)

  # Feature flag that enables caching view fragments
  config.cache_views = ActiveModel::Type::Boolean.new.cast(ENV.fetch('STORYBLOK_CACHE_VIEWS', false))
end
