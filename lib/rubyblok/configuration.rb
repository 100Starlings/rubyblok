module Rubyblok
  class Configuration
    attr_accessor :api_token, :version, :component_path

    def property=(value)
      @property = value
    end
  end
end
