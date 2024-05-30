# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require 'rubyblok'
require 'action_controller'
require 'pry'
require 'webmock/rspec'
require 'generator_spec'

require 'support/application_controller'
require 'support/webhook_controller'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
