# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mvn-get/'

Gem::Specification.new do |spec|
  spec.name          = "mvn-get"
  spec.version       = MavenCentral.VERSION
  spec.authors       = ["HondaDai"]
  spec.email         = ["hondadai.tw@gmail.com"]
  spec.summary       = %q{mvn-get is a java toolkit for quickly checking and setting up library dependencies.}
  spec.description   = spec.summary
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rest-client", "~> 1.6.7"
  spec.add_development_dependency "json", "~> 1.7"
  spec.add_development_dependency "activesupport", "~> 4.2.1"
  spec.add_development_dependency "rest-client", "~> 0.19.1"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
