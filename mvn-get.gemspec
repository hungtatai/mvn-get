# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mvn-get/mvn-get.rb'

Gem::Specification.new do |spec|
  spec.name          = "mvn-get"
  spec.version       = MavenCentral.version
  spec.authors       = ["HondaDai"]
  spec.email         = ["hondadai.tw@gmail.com"]
  spec.summary       = %q{mvn-get is a java toolkit for quickly checking and setting up library dependencies.}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/HondaDai/mvn-get"
  spec.license       = "MIT"

  spec.files         = %w[mvn-get.gemspec] + Dir['*.md', 'bin/*', 'lib/**/*.rb']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client", '~> 1.6', '>= 1.6.7'
  spec.add_dependency "json", "~> 1.7", '>= 1.7'
  spec.add_dependency "activesupport", '~> 4.2', '>= 4.2.1'
  spec.add_dependency "thor", '~> 0.19.1'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
