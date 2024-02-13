module Rubyblok
  class Configuration
    attr_reader :property

    def initialize
      self.property = nil
    end

    def property=(value)
      @property = value
    end
  end
end
