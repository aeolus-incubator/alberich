require 'rails/generators'

module Alberich
  class InstallGenerator < Rails::Generators::Base
    desc "Copy Alberich default files"
    source_root File.expand_path('../templates', __FILE__)

    def copy_config
      copy_file "alberich.rb", "config/initializers/alberich.rb"
    end
    def show_readme
      readme 'README' if behavior == :invoke
    end
  end
end
