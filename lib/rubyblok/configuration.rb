module Rubyblok
  class Configuration
    attr_accessor :api_token, :version

    def initialize
      self.property = nil
    end

    def property=(value)
      @property = value
    end
  end
end
