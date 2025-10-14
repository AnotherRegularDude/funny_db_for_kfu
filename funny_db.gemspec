# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "funny_db/version"

Gem::Specification.new do |spec|
  spec.name          = "funny_db"
  spec.version       = FunnyDb::VERSION
  spec.authors       = ["JustRegularDude"]
  spec.email         = ["skuf@justregulardude.ru"]
  spec.summary       = "Just do my work for KFU, yooooooooooo!!111!!"
  spec.description   = "I love to code weird things and Docker, yooooooo!!111!!"
  spec.homepage      = "https://github.com/AnotherRegularDude"
  spec.license       = "MIT"

  spec.files = Dir["lib/**/*"] + Dir["bin/*"]
  spec.files += Dir["[A-Z]*"] + Dir["spec/**/*"]
  spec.files.reject! { |fn| fn.include? "Dockerfile" }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "oj"

  spec.required_ruby_version = ">= 3.2.0"
end
