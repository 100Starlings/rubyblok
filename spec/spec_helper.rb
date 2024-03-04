# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

require "action_controller"
require "pry"
require "redcarpet"
require "rubyblok"
require "storyblok"
require "webmock/rspec"

require "rubygems"
require "bundler/setup"

require_relative "support/application_controller"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end


