# -*- encoding: utf-8 -*-
require File.expand_path('../lib/log_weaver/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["raphael"]
  gem.email         = ["raphael.borowiecki@gmail.com"]
  gem.description   = %q{Weaves multiple log files into a single one using the timestamp in log entries.}
  gem.summary       = %q{See description.}
  gem.homepage      = ""

  gem.files         = `hg manifest`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "log_weaver"
  gem.require_paths = ["lib"]
  gem.version       = LogWeaver::VERSION
  gem.add_development_dependency('rdoc')
  gem.add_development_dependency('aruba')
  gem.add_development_dependency('rake','~> 0.9.2')
  gem.add_dependency('methadone', '~>1.2.1')
end
