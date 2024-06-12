# frozen_string_literal: true

module Rubyblok
  class Configuration
    attr_accessor :api_token, :auto_update, :cached, :cache_views, :component_path, :image_model_name,
                  :model_name, :use_cdn_images, :version, :webhook_secret
  end
end
