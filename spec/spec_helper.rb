# frozen_string_literal: true

ENV['RAILS_ENV'] = 'test'

require 'rubyblok'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
