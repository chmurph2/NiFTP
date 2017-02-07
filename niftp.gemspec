# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "niftp/version"

Gem::Specification.new do |s|
  s.name        = "niftp"
  s.version     = NiFTP::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Christopher R. Murphy"]
  s.email       = ["chmurph2+git@gmail.com"]
  s.homepage    = "https://github.com/chmurph2/NiFTP"
  s.summary     = %q{NiFTP makes Ruby's decidedly un-nifty Net::FTP library
    easier to use.}
  s.description = s.summary
  s.license     = "MIT"

  s.rubyforge_project = "niftp"

  # files
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # RDoc
  s.has_rdoc = true
  s.rdoc_options = '--include=examples --main README.md'
  s.extra_rdoc_files = ["README.md"] + Dir.glob("doc/*")

  # Dependencies
  s.add_dependency "double-bag-ftps",            ">= 0.1.3"
  s.add_dependency "retryable",                  ">= 2.0"
  s.add_dependency "i18n",                       ">= 0.5"
  s.add_development_dependency "minitest",       "~> 4.7"
  s.add_development_dependency "guard",          "~> 1.8.3"
  s.add_development_dependency "guard-minitest", "~> 1.0.1"
  s.add_development_dependency "mocha",          "~> 0.14"
  s.add_development_dependency "rake"
end
