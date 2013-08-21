# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tournakit/version'

Gem::Specification.new do |spec|
  spec.name          = "tournakit"
  spec.version       = Tournakit::VERSION
  spec.authors       = ["Christian Carter"]
  spec.email         = ["cdcarter@gmail.com"]
  spec.description   = %q{ACF Style Academic Competition Tools}
  spec.summary       = %q{A basic toolkit for mACF competition, with scoresheets, parsers, and more!}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'

  spec.add_runtime_dependency 'roo', '>= 1.12.1'
end
