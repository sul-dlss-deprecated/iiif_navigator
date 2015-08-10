# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'iiif/navigator/version'

Gem::Specification.new do |spec|
  spec.name          = "iiif_navigator"
  spec.version       = IIIF::Navigator::VERSION
  spec.licenses      = ['Apache-2.0']
  spec.platform      = Gem::Platform::RUBY

  spec.authors       = ["Darren L. Weber, Ph.D."]
  spec.email         = ["darren.weber@stanford.edu"]

  spec.summary       = "A ruby library to navigate a IIIF collection"
  spec.description   = "A ruby library to navigate a IIIF collection"
  spec.homepage      = "https://github.com/sul-dlss/iiif_navigator"

  # general utils
  spec.add_dependency 'json'
  spec.add_dependency 'uuid'
  # Use ENV for config
  spec.add_dependency 'dotenv'
  # RDF linked data
  spec.add_dependency 'addressable'
  spec.add_dependency 'linkeddata'
  # HTTP client and rack cache components
  spec.add_dependency 'rest-client'
  spec.add_dependency 'rest-client-components'
  spec.add_dependency 'rack-cache'
  # dalli is a memcached ruby client
  spec.add_dependency 'dalli'
  # Use pry for console and debug config
  spec.add_dependency 'pry'
  spec.add_dependency 'pry-doc'
  # cache simple RDF on redis
  spec.add_dependency 'hiredis'
  spec.add_dependency 'redis'

  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-ctags-bundler'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'

  git_files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  bin_files = %w(bin/console bin/ctags.rb bin/setup.sh bin/test.sh)
  dot_files = %w(.gitignore .travis.yml log/.gitignore)

  spec.files         = git_files - (bin_files + dot_files)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.bindir        = "exe"
  spec.require_paths = ["lib"]

end
