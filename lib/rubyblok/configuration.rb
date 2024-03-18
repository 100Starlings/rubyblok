module Rubyblok
  class Configuration
    attr_accessor :api_token, :version, :component_path, :webhook_secret

    attr_writer :property
  end
end
