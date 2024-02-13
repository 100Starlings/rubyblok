class GetStoryblokStory
  def self.call(story_id:)
    new(story_id:).call
  end

  def initialize(story_id:)
    @story_id = story_id
  end

  def call
    get_story
  end

  private

  def storyblok_client
    Storyblok::Client.new(
      token: Rubyblok.configuration.api_token
    )
  end

  def get_story
    storyblok_client.story(@story_id)['data']['story']
  end
end
