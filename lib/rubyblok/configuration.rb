# frozen_string_literal: true

module Rubyblok
  class Configuration
    attr_accessor :api_token, :version, :component_path, :webhook_secret, :model_name, :cached

    attr_writer :property
  end
end
