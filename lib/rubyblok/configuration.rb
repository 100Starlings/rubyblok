# frozen_string_literal: true

module Rubyblok
  class Configuration
    attr_accessor :api_token, :auto_update, :cached, :use_cdn_images, :component_path, :image_model_name,
                  :model_name, :version, :webhook_secret
  end
end
