$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "advanced_auth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "advanced_auth"
  s.version     = AdvancedAuth::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "ACA's primrary authentication module"
  s.description = "An authenticator based on Omniauth"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.textile"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.2.7"
  s.add_dependency "bcrypt-ruby"
  s.add_dependency "omniauth-twitter"
  s.add_dependency "omniauth-facebook"
  s.add_dependency "omniauth-google-oauth2"
  s.add_dependency "omniauth-google-apps"
  s.add_dependency "omniauth-identity"
  s.add_dependency "omniauth-openid"
  s.add_dependency "closure_tree"


  s.add_development_dependency "sqlite3"
end
