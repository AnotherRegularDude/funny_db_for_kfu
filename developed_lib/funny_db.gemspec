# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
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
  spec.files += Dir['[A-Z]*'] + Dir['test/**/*']
  spec.files.reject! { |fn| fn.include? 'Dockerfile' }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # I want to make good development dependencies
  spec.add_development_dependency 'bundler', '~>1.12'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-reporters'

  # And production...
  spec.add_runtime_dependency 'oj' # Optimize json, huray!
end
