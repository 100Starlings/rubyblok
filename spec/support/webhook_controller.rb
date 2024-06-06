# frozen_string_literal: true

require 'rubyblok/mixins/webhook'

class WebhookController < ApplicationController
  include Rubyblok::Mixins::Webhook
end
