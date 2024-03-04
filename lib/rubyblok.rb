# frozen_string_literal: true
require "hash_dot"

require_relative "rubyblok/helpers/storyblok_helper"
require_relative "rubyblok/version"
require_relative "rubyblok/configuration"
require_relative "rubyblok/services/get_storyblok_story"
require_relative "rubyblok/railtie" if defined?(Rails)

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
