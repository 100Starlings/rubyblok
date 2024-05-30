# frozen_string_literal: true

require 'rails/generators'

module Rubyblok
  module Generators
    class SitemapConfigGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __dir__)

      desc 'Generates a configuration for the sitemap_generator gem'

      def generate_sitemap_config
        copy_config
        add_sitemap_generator_gem
      end

      private

      def copy_config
        template('sitemap.rb.erb', 'config/sitemap.rb')
      end

      def add_sitemap_generator_gem
        append_to_file(gemfile_path) { "gem 'sitemap_generator'" } if add_sitemap_generator_gem?
      end

      def add_sitemap_generator_gem?
        !gemfile_content.match?(/\bsitemap_generator\b/)
      end

      def gemfile_content
        File.read(gemfile_path)
      end

      def gemfile_path
        Rails.root.join('Gemfile')
      end
    end
  end
end
