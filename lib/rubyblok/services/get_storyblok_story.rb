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

<<<<<<< HEAD
  def storyblok_client(version: "draft")
    Storyblok::Client.new(
      token: Rubyblok.configuration.api_token,
      version: Rubyblok.configuration.version
=======
  def storyblok_client
    Storyblok::Client.new(
      token: Rubyblok.configuration.api_token
>>>>>>> 5fdeda1 ([RB-133] Add specs and getstoryblokstory)
    )
  end

  def get_story
    storyblok_client.story(@story_id)['data']['story']
  end
end
