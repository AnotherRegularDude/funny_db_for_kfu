# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'funny_db/version'

Gem::Specification.new do |spec|
  spec.name          = 'funny_db'
  spec.version       = FunnyDb::VERSION
  spec.authors       = ['VanyaZ158']
  spec.email         = ['vanyaz158@gmail.com']
  spec.summary       = 'Just do my work for KFU, yooooooooooo!!111!!'
  spec.description   = 'I love to code weird things and Docker, yooooooo!!111!!'
  spec.homepage      = 'https://github.com/VanyaZ15'
  spec.license       = 'MIT'

  spec.files = Dir['lib/**/*'] + Dir['bin/*']
  spec.files += Dir['[A-Z]*'] + Dir['spec/**/*']
  spec.files.reject! { |fn| fn.include? 'Dockerfile' }
  spec.test_files    = spec.files.grep(%r{^(spec|features)/})
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # I want to make good development dependencies
  spec.add_development_dependency 'bundler', '~> 2.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rake-notes'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-config-umbrellio'

  # And production...
  spec.add_runtime_dependency 'oj' # Optimize json, huray!

  spec.required_ruby_version = '>= 3.4.0'
end
