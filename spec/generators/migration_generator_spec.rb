require "spec_helper"

RSpec.describe Rubyblok::Generators::MigrationGenerator, type: :generator do
  include Rails::Generators::Testing::Assertions

  let(:name) { "page_object" }

  tests(described_class)
  destination(File.join(Dir.tmpdir, "files"))

  before do
    connection_double = double('connection')

    allow(connection_double).to receive(:table_exists?).and_return(table_exists)
    allow(ActiveRecord::Base).to receive(:connection).and_return(connection_double)
    prepare_destination
    run_generator([name])
  end

  context "when the table doesn't exist" do
    let(:table_exists) { false }

    it "creates the migration file with the right content" do
      assert_migration("db/migrate/create_rubyblok_#{name.pluralize}.rb") do |migration|
        assert_match(/create_table/, migration)
      end
    end

    it "creates the model file" do
      assert_file("app/models/#{name}.rb") do |content|
        assert_match(/PageObject/, content)
      end
    end
  end

  context "when the table already exist" do
    let(:table_exists) { true }

    before do
      FileUtils.mkdir_p(File.join(destination_root, "app/models"))
      File.write(File.join(destination_root, "app/models/#{name}.rb"), "class PageObject < ApplicationRecord")
      allow($stdin).to receive(:gets).and_return("Y")
      run_generator([name])
    end

    it "create the migration file to update the right content" do
      assert_migration("db/migrate/update_rubyblok_#{name.pluralize}.rb") do |migration|
        assert_match(/add_column/, migration)
      end
    end

    it "creates the model file" do
      assert_file("app/models/#{name}.rb") do |content|
        assert_match(/include Rubyblok::Mixins:Model/, content)
      end
    end
  end
end
