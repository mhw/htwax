# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'htwax/version'

Gem::Specification.new do |spec|
  spec.name          = 'htwax'
  spec.version       = HtWax::VERSION
  spec.authors       = ['Mark H. Wilkinson']
  spec.email         = ['mhw@dangerous-techniques.com']
  spec.summary       = %q{An experimental HTTP client for APIs.}
  spec.description   = %q{An experimental HTTP client for APIs.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'faraday'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
