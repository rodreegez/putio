# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "putio"
  s.version     = "0.0.1.pre"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Adam Rogers"]
  s.email       = ["adam@rodreegez.com"]
  s.homepage    = "http://github.com/rodreegez/putio"
  s.summary     = %q{A ruby wrapper for the Putio API}
  s.description = %q{A simple ruby interface to the api at http://api.put.io}

  s.rubyforge_project = "putio"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency 'json', '1.4.6'
  s.add_dependency 'crack', '0.1.8'
  s.add_dependency 'hashie', '0.4.0'
end
