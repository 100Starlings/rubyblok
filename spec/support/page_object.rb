require "rubyblok/mixins/model"

class PageObject < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
  include Rubyblok::Mixins::Model
end
