# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "validator/version"

Gem::Specification.new do |s|
  s.name        = "validator"
  s.version     = Validator::VERSION
  s.authors     = ["Vitaliy Nahaylo"]
  s.email       = ["nahaylo@gmail.com"]
  s.homepage    = ""
  s.summary     = "Validator"
  s.description = "Validators for domains and ip addresses"

  s.rubyforge_project = "validator"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "ipaddress"
  s.add_runtime_dependency 'activemodel', ['>= 3.0.0', '< 3.2.0']
  s.add_development_dependency 'activesupport', ['>= 3.0.0', '< 3.2.0']
  s.add_development_dependency "rspec"
end
