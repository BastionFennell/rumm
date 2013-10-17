# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rumm/version'

Gem::Specification.new do |spec|
  spec.name          = "rumm"
  spec.version       = Rumm::VERSION
  spec.authors       = ["Charles Lowell"]
  spec.email         = ["cowboyd@thefrontside.net"]
  spec.description   = %q{Lift heavy things inside your Rackspace}
  spec.summary       = %q{CLI and API for managing Rackspace infrastructure}
  spec.homepage      = "https://github.com/rackspace/rumm"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.3"

  spec.add_dependency "mvcli", "~> 0.0.16"
  spec.add_dependency "fog", "~> 1.15.0"
end
