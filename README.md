# Rubyblok
## Introduction
Rubyblok is a versatile Ruby gem designed for a Content Management System (CMS) integration.
This gem offers an easy way to integrate a visual CMS - Storyblok - into your Rails app, providing you with quality-of-life features.

This integration allows you to edit your content online, preview it in real-time, and publish with just the click of a button.

In addition, Rubyblok provides an abstraction layer and stores all your content locally, reducing data usage and enhancing performance. This enables new functionalities that leverage the local data, such as global content search, sitemaps, and listings. Ultimately, this setup increases resilience by eliminating dependency on external data sources.

## Table of Contents
1. [Installation](#installation)
2. [Getting Started](#getting-started)
3. [Rubyblok tags](#rubyblok-tags)
4. [Sitemap configuration](#sitemap-configuration)
5. [How to Run Tests](#how-to-run-tests)
6. [Guide for Contributing](#guide-for-contributing)
7. [How to Contact Us](#how-to-contact-us)
8. [License](#license)

## Installation
Rubyblok 1.0 works with Rails 6.0 onwards. Run:
```bash
bundle add rubyblok
```

### Storyblok account and new space
[Click here](https://app.storyblok.com/#/signup) to create a free acount at Storyblok, the CMS platform where you will have access to the visual and real-time content editing.

Create a new Space, in _My Spaces > Add Space_. Select the free Community plan by clicking its "Continue" button and give your space a name.

Get your Storyblok API token in your account, at _Storyblok Space > Settings > Access tokens_ page. Copy the "Preview" access level key.

Add the key to your `STORYBLOK_API_TOKEN` in your env file, like this example:

```
STORYBLOK_API_TOKEN=<your API token>
```
You will also need to add the variables below to your env file:
```
STORYBLOK_VERSION=draft
STORYBLOK_WEBHOOK_SECRET=''
```

## Getting Started

### Necessary gems
You need to add some gems to your app for Rubyblok to work correctly. Run the following commands:

```bash
bundle add "storyblok"
bundle add "hash_dot"
bundle add "dotenv-rails"
```

### Hello world - Your first Rubyblok page
Let's get started with Rubyblok by creating your first page in three steps.
Note that it is important that you have your Storyblok space set up as described above, in the `Storyblok account and new space` section.

1. First, you need to run the install generator, which will create the initializer for you:
```bash
rails g rubyblok:install
```

2. Now let's generate and run a migration to create the `pages` table and the `Page` model:
```bash
rails g rubyblok:migration page

rails db:migrate
```

3. Finally, let's generate your first page:
```bash
rails g rubyblok:hello_world page
```
This will automatically create a new route, controller, views and styling for your hello world page.

For this example, go to the `rubyblok.rb` file and turn the caching option off:
```
config.cached = false
```

Now you have created your first Hello World page! Start your Rails server, access the '/pages' route and you will be able to see the page.

### Activate the visual editor 
Here are the steps to configure the visual editor at Storyblok. This allows you to see a preview of your changes in the Storyblok interface as you edit and save.

At Storyblok, select your Space and go to _Settings > Visual Editor_. 

In the "Location (default environment)" input, add your localhost address:
```
https://localhost:3333
```

Then we have to create a local proxy. For that, first create a PEM certificate for your `localhost`:

```bash
brew install mkcert
mkcert -install
mkcert localhost
```

This will create the `localhost-key.pem` and `localhost.pem` files.

To run the proxy, use the `local-ssl-proxy` tool:

```bash
npm install local-ssl-proxy -g
local-ssl-proxy --source 3333 --target 3000 --cert localhost.pem --key localhost-key.pem
```

This will start a proxy server.

By doing this initial setup, you are able to see your first Storyblok page inside your app and edit its content in the Storyblok admin interface 🎉

### Storyblok webhook
The Storyblok webhook will be responsible for updating and deleting content in the local database in case of changes. [Learn more here.](https://www.storyblok.com/docs/guide/in-depth/webhooks)

Generate the webhook controller:
```bash
rails g rubyblok:webhook_controller storyblok_webhook
```

## Rubyblok tags

### rubyblok_story_tag
Use this tag to render stories:
```
# Slug: full_slug of the storyblok story
<%= rubyblok_story_tag(slug) %>
```
The name of the storyblok blok should match the rails partial, ie the `header` storyblok blok should have a corresponding `_header.html.erb` partial in the `config.component_path` directory. The partial is called with a `blok` local variable which contains the storyblok blok properties.

### rubyblok_content_tag
It renders content of Text, TextArea, Markdown or Richtext storyblok fields.
```
<%= rubyblok_content_tag(content) %>
```

Optionally, you can use the `rubyblok_markdown_tag` or `rubyblok_richtext_tag` tags for rendering specific content.
```
# Markdown text
<%= rubyblok_markdown_tag("this is a **mark** down") %>
# Output: "<p>this is a <strong>mark</strong> down</p>"

# Richtext
text = { 
         "type" => "doc",
         "content" => [
           { "type" => "paragraph",
             "content" => [{ "text" => "this is a richtext", "type" => "text" }]
            }
         ]
       }

<%= rubyblok_richtext_tag text > %> 
# Output: "<p>this is a richtext</p>"
```

### rubyblok_blocks_tag
Use this tag to render more than one component:
```
<%= rubyblok_blocks_tag(blok.bloks) %>
```

### Updating content manually at the caching layer
In case you need to update the caching layer with new content added to Storyblok, run the following command:
```
# Slug: full_slug of the storyblok story
storyblok_story_content = Rubyblok::Services::GetStoryblokStory.call(slug: slug)
<MODEL_NAME>.find_or_initialize_by(storyblok_story_slug: page)
     .update(storyblok_story_content:, storyblok_story_id: storyblok_story_content["id"])
```

## Sitemap configuration
You can generate a sitemap configuration for your website with the following command:
```
rails g rubyblok:sitemap_config
```
This generator will create a sitemap configuration for the `sitemap_generator` gem and add the gem to your Gemfile in case it's not already there.
The sitemap is generated only for cached content. Please make sure that the `cached` configuration value is `true` on `config/initializers/rubyblok.rb`.
Open `config/sitemap.rb` and add your hostname:
```
# ...

# TODO: Configure your hostname here
SitemapGenerator::Sitemap.default_host = ''

# ...
```
For example:
```
# ...

# TODO: Configure your hostname here
SitemapGenerator::Sitemap.default_host = 'https://myhost.com'

# ...
```
In order to generate your sitemap or customize this configuration, please read [the sitemap_generator gem documentation](https://github.com/kjvarga/sitemap_generator).

## How to Run Tests
You can run unit tests for RubyBlok with the following command:
```
bundle exec rspec
```

## Guide for Contributing
Contributions are made to this repository via Issues and Pull Requests (PRs).
Issues should be used to report bugs, request a new feature, or to discuss potential changes before a PR is created.

## How to Contact Us
For any inquiries, reach out to us at: info@rubyblok.com

## License
RubyBlok is released under the MIT License.
