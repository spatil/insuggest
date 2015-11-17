# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'insuggest/version'

Gem::Specification.new do |spec|
  spec.name          = "insuggest"
  spec.version       = Insuggest::VERSION
  spec.authors       = ["Shailesh Patil"]
  spec.email         = ["shailesh@joshsoftware.com"]
  spec.summary       = "Find the insurance discounts and depreciations" 
  spec.description   = "This gem will provide a way to find the accurate discounts and depreciations from the uploaded data" 
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'elasticsearch', '~> 1.0.5'
  spec.add_dependency 'elasticsearch-model', '~> 0.1.5'
  spec.add_dependency 'elasticsearch-persistence', '~> 0.1.5'
  spec.add_dependency 'elasticsearch-rails', '~> 0.1.5'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
