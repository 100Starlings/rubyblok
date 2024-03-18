require "rails/generators"
require "rails/generators/active_record"

module Rubyblok
  module Generators
    class MigrationGenerator < ::Rails::Generators::NamedBase
      include ::Rails::Generators::Migration
      source_root File.expand_path("../templates", __dir__)
      desc "Installs Rubyblok migration and model files."

      def install
        if table_exist?
          migration_template("migration_update.rb.erb", "db/migrate/update_rubyblok_#{plural_file_name}.rb",
                             migration_version:)
        else
          migration_template("migration_create.rb.erb", "db/migrate/create_rubyblok_#{plural_file_name}.rb",
                             migration_version:)
        end

        create_or_update_model
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
        mixins_code = "\n  include Rubyblok::Mixins:Model\n"

        insert_into_file model_path, after: "class #{class_name} < ApplicationRecord" do
          mixins_code
        end
      end

      def generate_new_model_from_template
        template("model.rb.erb", "app/models/#{file_name}.rb")
      end
    end
  end
end
