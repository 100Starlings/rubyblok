module Rubyblok
  module Mixins
    module Webhook
      extend ActiveSupport::Concern

      included do
        def create
          # TODO: Waiting [RB-223] - Caching Storybloks pages
          render json: {success: true}
        end
      end
    end
  end
end
