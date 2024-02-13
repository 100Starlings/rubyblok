# frozen_string_literal: true

ENV['RAILS_ENV'] = "test"

require "rubyblok"
require "pry"
require "webmock/rspec"
require "storyblok"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end


