# frozen_string_literal: true

require_relative 'helpers/storyblok_helper'

module Rubyblok
  class Railtie < Rails::Railtie
    initializer 'rubyblok.storyblok_helper' do
      ActiveSupport.on_load(:action_view) { include StoryblokHelper }
    end
  end
end
