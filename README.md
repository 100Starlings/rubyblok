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
Rubyblok 1.0 works with Rails 6.0 onwards. Run:
```
bundle add rubyblok
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

Now let's generate and run a migration to create the `pages` table and the `Page` model:
```bash
rails g rubyblok:migration PAGE

rails db:migrate
```

Then, generate the webhook controller:
```bash
rails g rubyblok:webhook_controller STORYBLOK_WEBHOOK
```
It also adds this line to your `routes.rb` file:
```
resources :storyblok_webhook, only: :create
```
The Storyblok webhook is responsible for updating and deleting content in our local database in case of changes of content in Storyblok.

Finally, generate the home controller:
```bash
rails g controller home_controller
```
Add the following code to your home controller:
```
def index
  response.headers['X-FRAME-OPTIONS'] = 'ALLOWALL'
end
```

Add this code to your app/views/home/index.html.erb file:
```
<%= rubyblok_story_tag('home') %>
```
Configure your `routes.rb` file to call the home controller. For example, adding this line:
```
root to: 'home#index'
```

Create a `shared/storyblok` directory in the `views` directory, this directory is going to store the partials that render Storyblok components.
You can change the folder settings at the `rubyblok.rb` file as needed:
```
config.component_path = "shared/storyblok"
```

Inside the `views/shared/storyblok` folder, create a file named `_page.html.erb` with the following code:
```
<%= rubyblok_blocks_tag(blok.body) %>
```

And then create another file for the hero section block `_hero_section.html.erb` (more explanation on that later):
```
<section>
  <div>
    <%= rubyblok_content_tag(blok.headline) %>
    <%= rubyblok_content_tag(blok.subheadline) %>
  </div>
</section>
```

### Creating your page at Storyblok
1. Once you're logged in, access your new space in the "My Spaces" section
2. Go to the "Content" section
3. Click the CTA "Create new" > Story
4. Name your story "Home", so it connects to our previous code. The content type is "Page".
5. Open your new story to start editing.
6. On the right side, you can add new blocks to your page. Create a new block by clicking the "+ Add Block" button.
7. This will open the Insert block section, then create the new "hero_section" block by typing its name in the search input.
8. Click the "Create new hero_section" CTA 
9. Add the "headline" and "subheadline" text fields to the new Hero Section and save.
10. In your new Hero Section block, add any text you want to it.
11. Click the Publish button in the right top corner.

Now you have your first demo page and block created. Start your rails server and you will be able to see it in your application.

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

You can do the following in case you need to update the caching layer with some content that already exists in Storyblok:
```
# Slug: full_slug of the storyblok story
storyblok_story_content = Rubyblok::Services::GetStoryblokStory.call(slug: slug)
<MODEL_NAME>.find_or_initialize_by(storyblok_story_slug: page)
     .update(storyblok_story_content:, storyblok_story_id: storyblok_story_content["id"])
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
