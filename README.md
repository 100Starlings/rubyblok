# Rubyblok
## Introduction
Rubyblok is a versatile Ruby gem designed for a Content Management System (CMS) integration.
This gem offers an easy way to integrate a visual CMS - Storyblok - into your Rails app, providing you with quality-of-life features.
This integration allows you to edit your content online, preview it in real-time, and publish with just the click of a button.
In addition, Rubyblok provides an abstraction layer and stores all your content locally, reducing data usage and enhancing performance. This enables new functionalities that leverage the local data, such as global content search, sitemaps, and listings. Ultimately, this setup increases resilience by eliminating dependency on external data sources.

## Table of Contents
[Installation](#installation)
[Getting Started](#started) 🚧
[Rubyblok tags](#tags)
[How to Run Tests](#tests)
[Guide for Contributing](#guide)
[How to Contact Us](#contact)
[License](#license)

## Installation {#installation}
To install Rubyblok, add the following line to your Gemfile and run bundle install:
```
gem 'rubyblok'
```

Or install it manually:
```
gem install rubyblok
```

Or you can install a different branch by specifying the 'ref:' label in your Gemfile:
```
gem 'rubyblok', git: '<https://github.com/100Starlings/rubyblok>', ref: '2bb1059'
```

### Storyblok account and variables
Click here to create a free acount at Storyblok, the CMS platform where you will have access to the visual and real-time content editing.
Get your Storyblok API token in your account, at Storyblok Space > Settings > Access tokens page. Copy the "Preview" access level key.
Add the key to your STORYBLOK_API_TOKEN in your env file, like this example:
```
STORYBLOK_API_TOKEN=<your API token>
```
You will also need to add the variables below to your env file:
```
STORYBLOK_VERSION=draft
STORYBLOK_WEBHOOK_SECRET=''
```

## Getting Started {#started} 🚧
[WIP]

## Rubyblok tags {#tags}
### rubyblok_story_tag
Use this tag to create pages:
```
# Pages, e.g: views/pages/index.html.erb
<%= rubyblok_story_tag(@slug) %>
```

### rubyblok_editable_tag
Use this tag to create stories:
```
# Story, e.g: views/shared/storyblok/_story.rb
<%= rubyblok_editable_tag(blok) %> #New Syntax
```

### rubyblok_component_tag
It's not being used directly, but you can use it by passing a specific component to be rendered. By default, it uses 'blok.component' as a partial, but you can change this parameter, for example:
```
# As a simple component
<%= rubyblok_component_tag blok: blok %>
#Specifying the partial
<%= rubyblok_component_tag blok: blok, partial: "section" %>
```

### rubyblok_content_tag
The new syntax will identify which type of content you are trying to render (e.g., Markdown text or Rich Text).
```
#Content, e.g: views/shared/storyblok/_contact_section.html.erb
<%= rubyblok_content_tag(blok.header) %> #New Syntax
```

If you know which type of text you want to render, you can use these methods directly with `rubyblok_markdown_tag` or `rubyblok_richtext_tag`.
```
# Markdown text
blok = { "text" => "this is a **mark** down" }.to_dot

<%= rubyblok_markdown_tag(blok.text) %>
#Outuput: "<p>this is a <strong>mark</strong> down</p>"

# Richtext
blok = { "type" => "doc",
      "content" => [
        { "type" => "paragraph",
          "content" =>
            [{ "text" => "this is a richtext",
               "type" => "text" }]}]}.to_dot

<%= rubyblok_richtext_tag blok: blok > %> 
#Output: "<p>this is a richtext</p>"
```

### rubyblok_blocks_tag
Use this tag to render more than one component:
```
<%= rubyblok_blocks_tag(blok.section_content) %>
```

## How to Run Tests {#tests}
You can run unit tests for RubyBlok with the following command:
```
bundle exec rspec
```

## Guide for Contributing {#guide}
Contributions are made to this repository via Issues and Pull Requests (PRs).
Issues should be used to report bugs, request a new feature, or to discuss potential changes before a PR is created.

## How to Contact Us {#contact}
For any inquiries, reach out to us at: info@rubyblok.com

## License {#license}
RubyBlok is released under the MIT License.
