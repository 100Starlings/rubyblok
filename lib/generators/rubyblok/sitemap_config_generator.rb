require "rails/generators"

module Rubyblok
  module Generators
    class SitemapConfigGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __dir__)

      desc "Generates a configuration for the sitemap_generator gem"

      def generate_sitemap_config
        copy_config
        add_sitemap_gem
      end

      private

      def copy_config
        template("sitemap.rb.erb", "config/sitemap.rb")
      end

      def add_sitemap_gem
        append_to_file "Gemfile" do
          "gem 'sitemap_generator'"
        end
      end
    end
  end
end
