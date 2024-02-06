require 'thor'

module Rubyblok
  class CLI < Thor
    desc 'setup', 'Set up Rubyblok development environment'
    def setup
      # Implement the setup logic here, following the user story
      # Use asdf-vm, install PostgreSQL, bundle install, rails db:setup, etc.
      puts 'Setting up Rubyblok environment...'
    end

    desc 'console', 'Open an interactive Ruby console with Rubyblok environment loaded'
    def console
      # Implement the console command logic here
      puts 'Opening Rubyblok console...'
    end

    desc 'rails', 'Execute Rails-specific tasks'
    def rails(task)
      # Implement Rails-specific tasks logic here
      puts "Executing Rails task: #{task}..."
    end
  end
end
