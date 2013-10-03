# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'google_hangout/version'

Gem::Specification.new do |spec|
  spec.name          = "google_hangout"
  spec.version       = GoogleHangout::VERSION
  spec.authors       = ["Leon Miller-Out"]
  spec.email         = ["leon@singlebrook.com"]
  spec.description   = %q{Launches a fullscreen Google Hangout in Firefox}
  spec.summary       = %q{Launches a fullscreen Google Hangout in Firefox}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "capybara"
  spec.add_dependency "selenium-webdriver"
end
