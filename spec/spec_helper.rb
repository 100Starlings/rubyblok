# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require 'rubyblok'
require 'action_controller'
require 'pry'
require 'webmock/rspec'
require 'generator_spec'

require 'support/application_controller'
require 'support/database_config'
require 'support/page_object'
require 'support/webhook_controller'

include DatabaseConfig # rubocop:disable Style/MixinUsage

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  init_database

  config.before(:each) do # rubocop:disable RSpec/HookArgument
    truncate_database
  end
end
