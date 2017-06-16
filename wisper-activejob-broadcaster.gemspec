# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wisper/activejob/broadcaster/version'

Gem::Specification.new do |spec|
  spec.name          = "wisper-activejob-broadcaster"
  spec.version       = Wisper::Activejob::Broadcaster::VERSION
  spec.authors       = ['BetterUp Developers']
  spec.email         = ['developers@betterup.co']

  spec.summary       = %q{Broadcast wisper events into activejob queues}
  spec.homepage      = "https://github.com/betterup/wisper-activejob-broadcaster"
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "wisper"
  spec.add_runtime_dependency "activejob"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
