# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rax/version'

Gem::Specification.new do |spec|
  spec.name          = "rax"
  spec.version       = Rax::VERSION
  spec.authors       = ["Charles Lowell"]
  spec.email         = ["cowboyd@thefrontside.net"]
  spec.description   = %q{Lift heavy things inside your Rackspace}
  spec.summary       = %q{CLI and API for managing Rackspace infrastructure}
  spec.homepage      = "https://github.com/cowboyd/rax"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mvcli", "~> 0.0.3"
  spec.add_dependency "fog", "~> 1.11.0"
  spec.add_dependency "netrc"
end
