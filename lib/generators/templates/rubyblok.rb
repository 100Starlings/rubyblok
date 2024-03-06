Rubyblok.configure do |config|
  config.api_token = ENV.fetch("STORYBLOK_API_TOKEN")
  config.version = ENV.fetch("STORYBLOK_VERSION")
  config.component_path = "shared/storyblok"
end
