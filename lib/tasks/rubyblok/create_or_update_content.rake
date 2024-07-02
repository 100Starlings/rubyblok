# frozen_string_literal: true

PER_PAGE = 50

namespace :rubyblok do
  desc 'Create or update cached Storyblok stories'
  task :create_or_update_content, [:version] => [:environment] do |_task, args|
    include Rubyblok::Mixins::ModelCacheClass

    args.with_defaults(version: Rubyblok.configuration.version)

    raise ArgumentError, "Invalid version \"#{args[:version]}\"" unless %w[draft published].include?(args[:version])

    client = storyblok_client(args[:version])
    page = 1

    loop do
      stories = get_stories(client:, page:)
      break if stories.empty?

      stories.each { |story| model_cache_class.find_or_create(story) }

      page += 1

      sleep 1
    end
  end

  def storyblok_client(version)
    Storyblok::Client.new(token: Rubyblok.configuration.api_token, version:)
  end

  def get_stories(client:, page:)
    client.stories(page:, per_page: PER_PAGE).dig('data', 'stories')
  end
end
