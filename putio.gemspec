Gem::Specification.new do |s|
  s.name        = "putio"
  s.version     = "0.0.2"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Adam Rogers", "Bilawal Hameed"]
  s.email       = ["adam@rodreegez.com", "bilawal@games.com"]
  s.homepage    = "http://github.com/rodreegez/putio"
  s.summary     = %q{Ruby wrapper for Put.io API}
  s.description = %q{A lightweight and simple Ruby interface to the Put.io cloud service API available at http://api.put.io}

  s.rubyforge_project = "putio"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency 'curb', '0.8.4'
  s.add_dependency 'json', '1.8.0'
  s.add_dependency 'hashie', '2.0.5'
end
