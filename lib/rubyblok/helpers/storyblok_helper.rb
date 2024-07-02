# frozen_string_literal: true

require 'rubyblok/mixins/model_cache_class'

module StoryblokHelper
  include Rubyblok::Mixins::ModelCacheClass

  def rubyblok_content_tag(content)
    return if content.blank?

    if content.is_a?(String)
      rubyblok_markdown_tag(content)
    else
      rubyblok_richtext_tag(content)
    end
  end

  def rubyblok_story_tag(slug)
    story = get_story(slug)
    content = story['content'].to_dot

    template = <<-ERB
      <% cache_key = "rubyblok/#{story['id']}-#{Digest::SHA1.hexdigest(story.to_json)}" %>
      <% cache_if use_cache, cache_key do %>
        <%= rubyblok_component_tag(partial: content.component, blok: content) %>
      <% end %>
    ERB

    render_inline_partial template:, locals: { content:, use_cache: Rubyblok.configuration.cache_views }
  end

  def rubyblok_component_tag(blok:, partial: blok.component)
    return if invisible_on_production?(blok)

    render_partial(partial:, locals: { blok: }).prepend(rubyblok_editable_tag(blok).to_s)
  end

  def invisible_on_production?(blok)
    Rails.env.production? && blok.fetch('invisible_on_production', false)
  end

  # rubocop:disable Rails/OutputSafety
  def rubyblok_markdown_tag(content)
    markdown_renderer.render(content).html_safe
  end

  def rubyblok_richtext_tag(content)
    rich_text_renderer.render(content).html_safe
  end
  # rubocop:enable Rails/OutputSafety

  def rubyblok_blocks_tag(bloks)
    template =
      %{<% bloks.each do |blok| %>
            <%= rubyblok_component_tag(blok:) %>
        <% end %>}

    render_inline_partial template:, locals: { bloks: }
  end

  def get_story_content(slug)
    get_story(slug)['content'].to_dot
  end

  private

  def get_story(slug)
    return get_story_via_api(slug) unless cached?

    if update_storyblok?
      get_story_via_api(slug, save: true)
    else
      get_story_via_cache(slug)
    end
  end

  def get_story_via_api(slug, save: false)
    story = Rubyblok::Services::GetStoryblokStory.call(slug:)
    replace_storyblok_url(story).tap do |storyblok_story|
      model_cache_class.find_or_create(storyblok_story) if save
    end
  end

  def get_story_via_cache(slug)
    model_cache_class.fetch_content(slug)
  end

  def replace_storyblok_url(story)
    Rubyblok::Services::ReplaceStoryblokUrl.call(story:)
  end

  def rich_text_renderer
    ctx = {}
    path = component_path
    @rich_text_renderer ||=
      Storyblok::Richtext::HtmlRenderer.new.tap do |html_renderer|
        html_renderer.set_component_resolver(lambda { |component, data|
          ApplicationController.render(partial: "#{path}/#{component}", locals: ctx.merge(blok: data))
        })
      end
  end

  def markdown_renderer
    @markdown_renderer ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end

  # rubocop:disable Rails/OutputSafety
  def rubyblok_editable_tag(component)
    component['_editable']&.html_safe
  end
  # rubocop:enable Rails/OutputSafety

  def component_path
    Rubyblok.configuration.component_path
  end

  def render_partial(partial:, locals:)
    ApplicationController.render partial: "#{component_path}/#{partial}", locals:
  end

  def render_inline_partial(template:, locals:)
    ApplicationController.render inline: template, locals:
  end

  def cached?
    Rubyblok.configuration.cached
  end

  def auto_update?
    Rubyblok.configuration.auto_update
  end

  def update_storyblok?
    auto_update? || params[:storyblok] == 'update'
  end
end
