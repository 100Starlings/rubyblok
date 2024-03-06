module Rubyblok
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __dir__)

      desc "Generates an initializer file."

      def copy_initializer
        template("rubyblok.rb", "config/initializers/rubyblok.rb")
      end
    end
  end
end
