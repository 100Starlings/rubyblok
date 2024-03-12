require "rubyblok/helpers/storyblok_helper"

class ApplicationController < ::ActionController::Base
  helper StoryblokHelper

  prepend_view_path 'spec/support/views'
end

