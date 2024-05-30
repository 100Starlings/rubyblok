# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rubyblok::Generators::WebhookControllerGenerator, type: :generator do
  include Rails::Generators::Testing::Assertions

  let(:name) { 'page_object' }
  let(:result) { run_generator([name]) }

  tests(described_class)
  destination(File.join(Dir.tmpdir, 'files'))

  before { prepare_destination }

  context 'when running the migration generator' do
    before do
      FileUtils.mkdir_p(File.join(destination_root, 'config'))
      File.write(File.join(destination_root, 'config/routes.rb'), "Rails.application.routes.draw do \n end")
    end

    it 'creates the controller file' do
      expect(result).to include('create  app/controllers/page_object_controller.rb')
    end

    it 'inserts the route' do
      expect(result).to include('insert  config/routes.rb')
    end
  end
end
