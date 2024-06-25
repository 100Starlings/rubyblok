# frozen_string_literal: true

PER_PAGE = 50

namespace :rubyblok do # rubocop:disable Metrics/BlockLength
  desc 'Create or update cached Storyblok stories'
  task :create_or_update_content, [:version] => [:environment] do |_task, args|
    args.with_defaults(version: Rubyblok.configuration.version)

    raise ArgumentError, "Invalid version \"#{args[:version]}\"" unless %w[draft published].include?(args[:version])

    client = storyblok_client(args[:version])
    page = 1

    loop do
      stories = get_stories(client:, page:)
      break if stories.empty?

      stories.each { |story| save_or_update(story) }

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

  def save_or_update(story)
    model_object = model_class.find_or_initialize_by(storyblok_story_id: story['id'])
    model_object.assign_attributes(storyblok_story_content: story, storyblok_story_slug: story['full_slug'])
    model_object.save!
  end

  def model_class
    Rubyblok.configuration.model_name.classify.constantize
  end
end
