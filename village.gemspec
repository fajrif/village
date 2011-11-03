Gem::Specification.new do |s|
  s.name        = "village"
  s.version     = "2.1.1"
  s.platform    = Gem::Platform::RUBY
  s.rubyforge_project = "village"
  s.authors     = "Fajri Fachriansyah"
  s.email       = "fajri82@gmail.com"
  s.homepage    = "https://github.com/fajrif/village"
  s.summary     = "Simple static content pages and blog engine for Rails 3."
  s.description = "Simple static content pages and blog engine for Rails 3."
  
  s.files = Dir["{app,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "Gemfile", "Guardfile", "README.md"]
  s.require_paths = ["lib"]
  
  s.add_dependency('rails', '>= 3.0.0')
  s.add_dependency('haml', '~> 3.1')
  s.add_dependency('tilt', '~> 1.3')
  s.add_dependency('kaminari', '>= 0.12.0')
  s.add_dependency('gravtastic')
  s.add_dependency('nokogiri')
  
end
