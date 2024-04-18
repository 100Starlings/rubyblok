require "rails/generators"

module Rubyblok
  module Generators
    class HelloWorldGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __dir__)

      desc 'Generates a "Hello, world" Rubyblok page.'

      def generate_hello_world
        add_controller
        copy_views
      end

      private

      def add_controller
        template("hello_world_generator/controller.rb.erb", "app/controllers/#{controller_filename}")

        add_route
      end

      def add_route
        insert_into_file("config/routes.rb", after: "Rails.application.routes.draw do") do
          "\n  get '/(:page)' => 'pages#index', defaults: { page: :home }\n"
        end
      end

      def copy_views
        template("hello_world_generator/index.html.erb", "app/views/#{model_views_path}/index.html.erb")
        template("hello_world_generator/_feature.html.erb", "app/views/#{destination_partial_path}/_feature.html.erb")
        template("hello_world_generator/_page.html.erb", "app/views/#{destination_partial_path}/_page.html.erb")
        template("hello_world_generator/_grid.html.erb", "app/views/#{destination_partial_path}/_grid.html.erb")
        template("hello_world_generator/_teaser.html.erb", "app/views/#{destination_partial_path}/_teaser.html.erb")

        copy_file("hello_world_generator/styles.css", "app/assets/stylesheets/hello.css")
      end

      def controller_filename
        @controller_filename ||= "#{model_views_path}_controller.rb"
      end

      def model_views_path
        @model_views_path ||= plural_model_name.downcase
      end

      def plural_model_name
        @plural_model_name ||= Rubyblok.configuration.model_name.pluralize
      end

      def destination_partial_path
        @destination_partial_path ||= Rubyblok.configuration.component_path
      end
    end
  end
end
