$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "alberich/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "alberich"
  s.version     = Alberich::VERSION
  s.authors     = ["Scott Seago"]
  s.email       = ["aeolus-devel@lists.fedorahosted.org"]
  s.homepage    = "https://github.com/aeolus-incubator/alberich"
  s.summary     = "Model-integrated permissions infrastructure for Rails projects."
  s.description = "Alberich is a model-integrated permissions engine that allows access control, and list filtering based on user and group-assigned permissions both globally and at an individual resouce level."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["{spec,test}/**/*"]

  s.add_dependency "rails", "~> 3.2.8"
  s.add_dependency "haml"
  s.add_dependency "nokogiri"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "cucumber-rails"
  s.add_development_dependency "database_cleaner"
  s.add_development_dependency "factory_girl_rails"
end
