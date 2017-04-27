# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fastlane/plugin/get_product_bundle_id/version'

Gem::Specification.new do |spec|
  spec.name          = 'fastlane-plugin-get_product_bundle_id'
  spec.version       = Fastlane::GetProductBundleId::VERSION
  spec.author        = %q{Lyndsey Ferguson}
  spec.email         = %q{ldf.public+github@outlook.com}

  spec.summary       = %q{Gets PRODUCT_BUNDLE_IDENTIFIER from the first buildable target in a given scheme}
  spec.homepage      = "https://github.com/lyndsey-ferguson/fastlane-plugin-get_product_bundle_id"
  spec.license       = "MIT"

  spec.files         = Dir["lib/**/*"] + %w(README.md LICENSE)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'xcodeproj'

  # Don't add a dependency to fastlane or fastlane_re
  # since this would cause a circular dependency

  # spec.add_dependency 'your-dependency', '~> 1.0.0'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'fastlane', '>= 2.18.3'
end
