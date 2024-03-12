# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

require "rails"
require "action_controller"
require "pry"
require "redcarpet"

require "storyblok"
require "webmock/rspec"

require "rubygems"
require "bundler/setup"
require "rubyblok"
require "generator_spec"
require "rails/generators"
require "rails/generators/active_record"

require_relative "support/application_controller"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
