# frozen_string_literal: true

require 'active_support/concern'

module Rubyblok
  module Mixins
    module ModelCacheClass
      extend ActiveSupport::Concern

      def model_cache_class
        Rubyblok.configuration.model_name.classify.constantize
      end
    end
  end
end
