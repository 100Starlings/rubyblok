require "rails/generators"

module Rubyblok
  module Generators
    class HelloWorldGenerator < Rails::Generators::NamedBase
      source_root File.expand_path("../templates", __dir__)

      desc 'Generates a "Hello, world" Rubyblok page.'

      def generate_hello_world
        add_controller
        add_route
        copy_views
      end

      private

      def add_controller
        template("hello_world_generator/controller.rb.erb", "app/controllers/#{plural_file_name}_controller.rb")
      end

      def add_route
        insert_into_file("config/routes.rb", after: "Rails.application.routes.draw do") do
          "\n  get '/#{plural_file_name}' => '#{plural_file_name}#index'\n"
        end
      end

      def copy_views
        template("hello_world_generator/index.html.erb", "app/views/#{plural_file_name}/index.html.erb")
        template("hello_world_generator/_feature.html.erb", "app/views/#{destination_partial_path}/_feature.html.erb")
        template("hello_world_generator/_page.html.erb", "app/views/#{destination_partial_path}/_page.html.erb")
        template("hello_world_generator/_grid.html.erb", "app/views/#{destination_partial_path}/_grid.html.erb")
        template("hello_world_generator/_teaser.html.erb", "app/views/#{destination_partial_path}/_teaser.html.erb")

        copy_file("hello_world_generator/styles.css", "app/assets/stylesheets/hello.css")
      end

      def destination_partial_path
        @destination_partial_path ||= Rubyblok.configuration.component_path
      end
    end
  end
end
