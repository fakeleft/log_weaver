# -*- encoding: utf-8 -*-
require File.expand_path('../lib/log_weaver/version', __FILE__)

Gem::Specification.new do |gem|
  gem.add_development_dependency('readme', '~> 0.1')
  require 'readme'
  r = Readme.file
  gem.authors       = r.authors
  gem.email         = ["raphael.borowiecki@gmail.com"]
  gem.description   = r.description
  gem.summary       = "Weaves log files by timestamp."
  gem.homepage      = r.homepage

  gem.files         = `hg manifest`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "log_weaver"
  gem.require_paths = ["lib"]
  gem.version       = LogWeaver::VERSION

  gem.add_development_dependency('yard', '~> 0.8')
  gem.add_development_dependency('unindent', '~> 1.0')
  gem.add_development_dependency('aruba', '~> 0.5')
  gem.add_development_dependency('cucumber', '~> 1.2')
  gem.add_development_dependency('rspec', '~> 2.13')
  gem.add_development_dependency('factory_girl', '~> 4.2')
  gem.add_development_dependency('rake','~> 0.9')
  gem.add_dependency('methadone', '~> 1.2')
  gem.add_dependency('require_all', '~> 1.2')
end



