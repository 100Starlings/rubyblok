# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

require "rails"
require "action_controller"
require "support/application_controller"
require "redcarpet"
require "storyblok"
require "webmock/rspec"

require "generator_spec"
require "pry"
require "webmock/rspec"
require "rubygems"
require "bundler/setup"
require "rubyblok"


require "rails/generators"
require "rails/generators/active_record"


RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
