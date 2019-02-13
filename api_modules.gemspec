$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "api_modules/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "api_modules"
  spec.version     = ApiModules::VERSION
  spec.authors     = ["Zenn"]
  spec.email       = ["app.zenn@gmail.com"]
  spec.homepage    = "https://github.com/yazumoto/api_modules"
  spec.summary     = "ApiModules."
  spec.description = "ApiModules."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.2"

  spec.add_development_dependency "sqlite3"
end
