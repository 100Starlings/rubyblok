module StoryblokHelper
  def rubyblok_content_tag(content)
    return if content.blank?

    if content.is_a?(String)
      rubyblok_markdown_tag(content)
    else
      rubyblok_richtext_tag(content)
    end
  end

  def rubyblok_story_tag(slug)
    content = get_story(slug)
    rubyblok_component_tag(partial: content.component, blok: content)
  end

  def rubyblok_component_tag(blok:, partial: blok.component)
    render_partial(partial:, locals: { blok: }).prepend(rubyblok_editable_tag(blok).to_s)
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

  def get_story(slug)
    if use_cache?
      get_story_via_cache(slug)["content"].to_dot
    else
      get_story_via_api(slug)["content"].to_dot
    end
  end

  private

  def get_story_via_api(slug)
    Rubyblok::Services::GetStoryblokStory.call(slug:)
  end

  def get_story_via_cache(slug)
    Rubyblok.configuration.model_name.classify.constantize.fetch_content(slug)
  end

  def rich_text_renderer # rubocop:disable Metrics/MethodLength
    ctx = {}
    path = component_path
    @rich_text_renderer ||=
      Storyblok::Richtext::HtmlRenderer.new.tap do |html_renderer|
        html_renderer.set_component_resolver(lambda { |component, data|
          ApplicationController.render(
            partial: "#{path}/#{component}",
            locals: ctx.merge(blok: data)
          )
        })
      end
  end

  def markdown_renderer
    @markdown_renderer ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  end

  # rubocop:disable Rails/OutputSafety
  def rubyblok_editable_tag(component)
    component["_editable"]&.html_safe
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

  def use_cache?
    Rubyblok.configuration.cached
  end
end
