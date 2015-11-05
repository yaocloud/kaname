# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kaname/version'

Gem::Specification.new do |spec|
  spec.name          = "kaname"
  spec.version       = Kaname::VERSION
  spec.authors       = ["SHIBATA Hiroshi"]
  spec.email         = ["hsbt@ruby-lang.org"]

  spec.summary       = %q{Identity configuration tool for OpenStack.}
  spec.description   = %q{Identity configuration tool for OpenStack. You can apply simple YAML definition into Keystone.}
  spec.homepage      = "https://github.com/hsbt/kaname"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "fog"
  spec.add_dependency "yao"
  spec.add_dependency "diffy"
  spec.add_dependency "hashdiff"
  spec.add_dependency "thor"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "webmock"
end
