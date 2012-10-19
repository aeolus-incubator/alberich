module Alberich
  class Engine < ::Rails::Engine
    isolate_namespace Alberich
    config.generators do |g|
      g.test_framework :rspec, :view_specs => false
      g.template_engine :haml
    end
  end
end
