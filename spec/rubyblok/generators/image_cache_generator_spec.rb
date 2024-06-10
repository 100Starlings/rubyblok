# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rubyblok::Generators::ImageCacheGenerator, type: :generator do
  include Rails::Generators::Testing::Assertions

  let(:name) { 'storyblok_image' }
  let(:connection) { double }

  tests(described_class)
  destination(File.join(Dir.tmpdir, 'files'))

  before do
    allow(connection).to receive(:table_exists?).and_return(table_exists)
    allow(ActiveRecord::Base).to receive(:connection).and_return(connection)

    prepare_destination

    run_generator([name])
  end

  context "when the table doesn't exist" do
    let(:table_exists) { false }

    it 'creates the migration file with the right content' do
      assert_migration("db/migrate/create_#{name.pluralize}.rb") do |migration|
        expect(migration).to match(/create_table/)
      end
    end

    it 'creates the model file and the uploader' do
      assert_file("app/models/#{name}.rb")
      assert_file("app/uploaders/#{name}_uploader.rb")
      assert_file('config/initializers/carrier_wave.rb')
    end
  end

  context 'when the table already exist' do
    let(:table_exists) { true }

    before do
      FileUtils.mkdir_p(File.join(destination_root, 'app/models'))
      File.write(File.join(destination_root, "app/models/#{name}.rb"), 'class StoryblokImage < ApplicationRecord')
      allow($stdin).to receive(:gets).and_return('Y')
      run_generator([name])
    end

    it 'create the migration file to update the right content' do
      assert_migration("db/migrate/update_#{name.pluralize}.rb") do |migration|
        expect(migration).to match(/add_column/)
      end
    end

    it 'creates the model file and the uploader' do
      assert_file("app/models/#{name}.rb") do |content|
        expect(content).to match(/mount_uploader :image, StoryblokImageUploader/)
      end

      assert_file("app/uploaders/#{name}_uploader.rb")
      assert_file('config/initializers/carrier_wave.rb')
    end
  end
end
