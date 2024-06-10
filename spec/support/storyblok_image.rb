# frozen_string_literal: true

class StoryblokImage < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
  def remote_image_url=(*)
    # emtpy
  end
end
