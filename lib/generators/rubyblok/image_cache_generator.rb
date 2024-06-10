# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/active_record'

module Rubyblok
  module Generators
    class ImageCacheGenerator < ::Rails::Generators::NamedBase
      include ::Rails::Generators::Migration
      source_root File.expand_path('../templates', __dir__)
      desc 'Installs image cache migration and model files.'

      def install
        if table_exist?
          migration_template('migration_update_image_cache.rb.erb', "db/migrate/update_#{plural_file_name}.rb",
                             migration_version:)
        else
          migration_template('migration_create_image_cache.rb.erb', "db/migrate/create_#{plural_file_name}.rb",
                             migration_version:)
        end

        create_or_update_model
        add_model_name_to_config
      end

      def self.next_migration_number(dirname)
        ActiveRecord::Generators::Base.next_migration_number(dirname)
      end

      private

      def migration_version
        "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
      end

      def table_exist?
        ActiveRecord::Base.connection.table_exists?(plural_file_name.to_sym)
      end

      def create_or_update_model
        if table_exist?
          add_mixins_to_existing_model
        else
          generate_new_model_from_template
        end
      end

      def add_mixins_to_existing_model
        model_path = "app/models/#{file_name}.rb"
        mixins_code = "\n  mount_uploader :image, #{class_name}Uploader\n"

        insert_into_file model_path, after: "class #{class_name} < ApplicationRecord" do
          mixins_code
        end

        add_uploader_and_config
      end

      def generate_new_model_from_template
        template('image_cache_model.rb.erb', "app/models/#{file_name}.rb")
        add_uploader_and_config
      end

      def add_uploader_and_config
        template('image_cache_uploader.rb.erb', "app/uploaders/#{file_name}_uploader.rb")
        template('carrier_wave_config.rb.erb', 'config/initializers/carrier_wave.rb')
      end

      def add_model_name_to_config
        model_path = 'config/initializers/rubyblok.rb'
        insert_into_file model_path, after: 'config.image_model_name     = "' do
          class_name
        end
      end
    end
  end
end
