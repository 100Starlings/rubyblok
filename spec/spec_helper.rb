# frozen_string_literal: true

ENV['RAILS_ENV'] = "test"

require "rails"
require "action_controller"
require "rubyblok"
require "pry"
require "webmock/rspec"
require "storyblok"
require "redcarpet"

require 'rubygems'
require 'bundler/setup'

require_relative "support/application_controller"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end


