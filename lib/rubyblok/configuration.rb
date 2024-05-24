module Rubyblok
  class Configuration
    attr_accessor :api_token, :auto_update, :cached, :cdn_images, :component_path, :model_name, :version,
                  :webhook_secret
  end
end
