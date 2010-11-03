# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "putio"
  s.version     = "0.0.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Adam Rogers"]
  s.email       = ["adam@rodreegez.com"]
  s.homepage    = "http://rubygems.org/gems/putio"
  s.summary     = %q{A ruby wrapper for the Putio API}
  s.description = %q{A simple ruby interface to the api at http://api.put.io}

  s.rubyforge_project = "putio"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency 'json', '1.4.6'

  s.add_development_dependency 'shoulda', '2.11.3'
  s.add_development_dependency 'omg'
end
