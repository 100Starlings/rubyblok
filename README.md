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
4. [How to Run Tests](#how-to-run-tests)
5. [Guide for Contributing](#guide-for-contributing)
6. [How to Contact Us](#how-to-contact-us)
7. [License](#license)

## Installation

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

[Click here](https://app.storyblok.com/?_gl=1*196uoul*_gcl_au*MTg1NjA5NjA0MS4xNzA5MDY5ODk3#!/signup) to create a free acount at Storyblok, the CMS platform where you will have access to the visual and real-time content editing.

Create a new Space, in _Spaces > Add Space_.

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

### Your first Rubyblok page
Let's get started with Rubyblok by creating our first page.

First, you need to run the install generator, which will create the initializer for you:
```bash
rails g rubyblok:install
```

Now let's generate and run a migration to create the `page` table:
```bash
rails g rubyblok:migration PAGE

rails db:migrate
```

Then, generate the webhook controller:
```bash
rails g rubyblok:webhook_controller STORYBLOK_WEBHOOK
```
Also add this code to your `routes.rb` file:
```
resources :storyblok_webhook, only: :create
```
The Storyblok webhook is responsible for updating and deleting content in our local database in case of changes of content in Storyblok.

Finally, generate the pages controller:
```bash
rails g controller pages_controller
```
Add the following code to your pages controller:
```
 include StoryblokHelper
    def index
        response.headers['X-FRAME-OPTIONS'] = 'ALLOWALL'
        @slug = "page"
        @page_content = GetStoryblokStory.call(slug: 'page').fetch('content')
    end
```

Add this code to your app/views/pages/index.html.erb file:
```
<%= rubyblok_story_tag(@slug) %>
```
Configure your `routes.rb` file to call the pages controller.

Create a `shared` directory in the `views` directory and a new folder named `storyblok` inside of it: `views/shared/storyblok`.
This directory is going to store the partials that call Storyblok components.
You can change the folder settings at the `rubyblok.rb` file as needed:
```
config.component_path = "shared/storyblok"
```

Inside the `views/shared/storyblok` folder, create a file named `_default-page.html.erb` with the following code:
```
<%= rubyblok_blocks_tag(blok.body) %>
```

And then create another file for the hero section block `_hero-section.html.erb` (more explanation on that later):
```
<section class="hero_section">
  <div class="hero_content_wrapper">
    <div class="hero_header flex flex-col items-center">
      <%= rubyblok_content_tag(blok.headline) %>
      <%= rubyblok_content_tag(blok.subheadline) %>
    </div>
  </div>
</section>
```

### Creating your page at Storyblok
1. Once you're logged in, access your new space in the "My Spaces" section
2. Go to the "Content" section
3. Click the CTA "Create new" > Story
4. Name your story "Page", so it connects to our previous code. The content type is "default page".
5. Open your new page to start editing.
6. On the right side, you can add new blocks to your page. Create a new block by clicking the plus button.
7. This will open the Insert block section, then add the "Hero Section" block.
8. Open your block and add any text you want to it.
9. Click the Publish button in the right top corner.

Now you have your first demo page and block created. Start your rails server and you will be able to see it in your application.

By doing this initial setup, you are able to see your first Storyblok page inside your app and edit its content in the Storyblok admin interface 🎉

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

This will start a proxy server. Now, just go to the Storyblok Space and it will be working! :tada:

## Rubyblok tags

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
