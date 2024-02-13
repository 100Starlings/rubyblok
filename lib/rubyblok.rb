# frozen_string_literal: true

require_relative "rubyblok/version"
require_relative "rubyblok/hello_world"
require_relative "rubyblok/configuration"
require_relative "rubyblok/services/get_storyblok_story"

module Rubyblok
  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  class Error < StandardError; end
  # Your code goes here...
end
